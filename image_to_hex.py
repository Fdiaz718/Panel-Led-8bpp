from PIL import Image
import sys
import os

# ==========================================
# CONFIGURACIÓN
# ==========================================
INPUT_IMAGE = "seal.jpg"  
OUTPUT_FILE = "image.hex" 
# ==========================================

def convert_image():
    if not os.path.exists(INPUT_IMAGE):
        print(f"ERROR: No existe archivo '{INPUT_IMAGE}'")
        return

    try:
        img = Image.open(INPUT_IMAGE)
        img = img.convert('RGB')
        img = img.resize((64, 64), Image.Resampling.LANCZOS)

        with open(OUTPUT_FILE, 'w') as f:
            for y in range(64):
                for x in range(64):
                    r, g, b = img.getpixel((x, y))
                    hex_val = f"{r:02X}{g:02X}{b:02X}"
                    f.write(f"{hex_val}\n")

        print(f"Archivo '{OUTPUT_FILE}' creado correctamente.")

    except Exception as e:
        print(f"Ocurrió un error: {e}")

if __name__ == "__main__":
    convert_image()
