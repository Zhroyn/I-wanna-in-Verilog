import os
import cv2
import numpy as np

def resize_image(im, fx=None, fy=None, width=None, height=None):
    if im is None:
        return None
    if fx or fy:
        fx = fy if fx is None else fx
        fy = fx if fy is None else fy
        im = cv2.resize(im, None, fx=fx, fy=fy)
    elif width or height:
        h, w = im.shape[:2]
        height = int(width * h / w) if height is None else height
        width = int(height * w / h) if width is None else width
        im = cv2.resize(im, (width, height))
    return im

def jpg_to_coe(im, save_path):
    # Convert the image to RGB444 format
    im[255 * 3 - np.sum(im, -1) < 54] = [255, 255, 255]
    im_rgb444 = im.astype('uint8') >> 4
    h, w = im_rgb444.shape[:2]

    # Save the RGB444 image as a COE file
    with open(save_path, 'w') as f:
        f.write('memory_initialization_radix=16;\n')
        f.write('memory_initialization_vector=\n')
        for y in range(h):
            for x in range(w):
                b, g, r = im_rgb444[y, x]
                coe_value = (r << 8) | (g << 4) | b
                f.write('{:03X},'.format(coe_value))
            f.write('\n')

def resize_and_save(image_path, save_path, fx=None, fy=None, width=None, height=None):
    im = cv2.imread(image_path)
    if im is not None:
        im = resize_image(im, fx, fy, width, height)
        cv2.imwrite(save_path, im)

def convert_and_save(image_path, save_path, fx=None, fy=None, width=None, height=None):
    im = cv2.imread(image_path)
    if im is not None:
        im = resize_image(im, fx, fy, width, height)
        jpg_to_coe(im, save_path)

if __name__ == '__main__':
    images = ['running4.jpg', 'cloud1.jpg', 'jumping2.jpg', 'apple2.jpg', 'running1.jpg',
              'falling1.jpg', 'falling2.jpg', 'junmping1.jpg', 'running2.jpg', 
              'cloud2.jpg', 'apple1.jpg', 'running3.jpg']
    for img in images:
        image_path = os.path.join("pics", img)
        coe_save_path = os.path.join("codes", "coe_files", img.replace("jpg", "coe"))
        convert_and_save(image_path, coe_save_path)
