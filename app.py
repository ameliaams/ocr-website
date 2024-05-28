from flask import Flask, render_template, request, jsonify, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import cv2
import numpy as np
import pytesseract
import base64
import re
from roboflow import Roboflow

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+pymysql://root:@localhost/posyandu_db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

# Model Database untuk tabel 'balita'
class Balita(db.Model):
    __tablename__ = 'balita'
    id_balita = db.Column(db.Integer, primary_key=True)
    nama_balita = db.Column(db.String(255), nullable=False)
    jenis_kelamin = db.Column(db.String(10), nullable=False)
    tgl_lahir = db.Column(db.Date, nullable=False)
    umur = db.Column(db.Integer, nullable=False)
    nama_ortu = db.Column(db.String(255), nullable=False)

# Model Database untuk tabel 'pengukuran'
class Pengukuran(db.Model):
    id_pengukuran = db.Column(db.Integer, primary_key=True, autoincrement=True)
    id_balita = db.Column(db.Integer, nullable=False)
    nama_balita = db.Column(db.String(255), nullable=False)
    berat_badan = db.Column(db.Float, nullable=False)

# Inisialisasi Roboflow
rf = Roboflow(api_key="Iiahj7wlNzkYVAtWGp2E")
project = rf.workspace().project("seven-segment-noe30")
model = project.version(1).model

# Fungsi untuk melakukan preprocessing gambar
def preprocess_image(image):
    # Grayscale
    gray_image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # Thresholding
    _, thresh_image = cv2.threshold(gray_image, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    return thresh_image

# Inisialisasi konfigurasi kustom untuk OCR
custom_config_text = r'--oem 3 --psm 7 -l ssd'

@app.route('/')
def index():
    balita_list = Balita.query.order_by(Balita.umur.desc()).all()
    return render_template('index.html', balita_list=balita_list)

@app.route('/pengukuran_add/<int:id_balita>', methods=['GET', 'POST'])
def pengukuran_add(id_balita):
    if request.method == 'POST':
        kategori = request.form['kategori']
        return redirect(url_for('kamera', id_balita=id_balita, kategori=kategori))
    return render_template('pengukuran_add.html', id_balita=id_balita)

@app.route('/kamera/<int:id_balita>', methods=['GET', 'POST'])
def kamera(id_balita):
    if request.method == 'POST':
        hasil_ocr = request.form['hasil_ocr']
        ocr = HasilOCR(id_balita=id_balita, hasil=hasil_ocr)
        db.session.add(ocr)
        db.session.commit()
        return redirect(url_for('index'))
    return render_template('kamera.html', id_balita=id_balita)

@app.route('/simpan-pengukuran', methods=['POST'])
def simpan_pengukuran():
    data = request.json
    id_balita = data['id_balita']
    hasil_ocr = data['hasil_ocr']

    # Ambil data balita berdasarkan ID
    balita = Balita.query.get(id_balita)
    if balita:
        pengukuran = Pengukuran(id_balita=id_balita, nama_balita=balita.nama_balita, berat_badan=float(hasil_ocr))
        db.session.add(pengukuran)
        db.session.commit()
        return jsonify({'message': 'Data pengukuran berhasil disimpan!'}), 200
    else:
        return jsonify({'message': 'Balita tidak ditemukan!'}), 404

@app.route('/upload', methods=['POST'])
def upload():
    image_data = request.json.get('image')

    encoded_data = image_data.split(',')[1]
    nparr = np.frombuffer(base64.b64decode(encoded_data), np.uint8)
    image = cv2.imdecode(nparr, cv2.IMREAD_COLOR)

    preprocessed_image = preprocess_image(image)
    prediction = model.predict(image, confidence=40, overlap=30).json()
    detections = prediction["predictions"]

    ocr_texts = []
    bounding_boxes = []

    for bounding_box in detections:
        x1 = int(bounding_box['x'] - bounding_box['width'] / 2)
        x2 = int(bounding_box['x'] + bounding_box['width'] / 2)
        y1 = int(bounding_box['y'] - bounding_box['height'] / 2)
        y2 = int(bounding_box['y'] + bounding_box['height'] / 2)
        
        roi = image[y1:y2, x1:x2]
        text = pytesseract.image_to_string(roi, config=custom_config_text)
        ocr_texts.append(text)
        bounding_boxes.append((x1, x2, y1, y2))

    sorted_bounding_boxes = sorted(bounding_boxes, key=lambda box: box[0])
    combined_text = ''.join([text.strip() for text in ocr_texts])

    for (x1, x2, y1, y2), text in zip(sorted_bounding_boxes, ocr_texts):
        cv2.rectangle(image, (x1, y1), (x2, y2), (0, 255, 0), 2)
        cv2.putText(image, text, (x1, y1 - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0, 255, 0), 2)

    sorted_detections = sorted(detections, key=lambda x: x['x'])
    classes = [detection["class"] for detection in sorted_detections]
    classes_string = "".join(classes)
    print("Hasil:", classes_string)

    dot_index = classes_string.find('.')
    print("Indeks posisi karakter titik pertama:", dot_index)

    x_min = min([box[0] for box in bounding_boxes])
    x_max = max([box[1] for box in bounding_boxes])
    y_min = min([box[2] for box in bounding_boxes])
    y_max = max([box[3] for box in bounding_boxes])

    cropped_image = image[y_min:y_max, x_min:x_max]
    preprocessed_image = preprocess_image(cropped_image)
    text = pytesseract.image_to_string(preprocessed_image, config=custom_config_text)
    print("Hasil OCR: ", text)

    if not text.strip() or len(text.strip()) <= 3 or len(text.strip()) > 4:
        result = classes_string
    else:
        text = re.sub(r'[^A-Za-z0-9]+', '', text)
        if isinstance(dot_index, int):
            if dot_index < len(text):
                text = text[:dot_index] + '.' + text[dot_index:]
        result = text

    return jsonify({'text': result})

if __name__ == '__main__':
    app.run(host='0.0.0.0')
