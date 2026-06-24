import os
from PIL import Image

os.makedirs('2x', exist_ok=True)
for f in os.listdir('1x'):
    if f.endswith('.png'):
        with Image.open(f'1x/{f}') as img:
            img.resize((img.width * 2, img.height * 2), Image.NEAREST).save(f'2x/{f}')