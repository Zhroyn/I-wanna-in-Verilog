import cv2

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

def jpg_to_coe(image_path, save_path, fx=None, fy=None, width=None, height=None):
    # Open and resize image
    im = cv2.imread(image_path)[..., :3]
    im = resize_image(im, fx, fy, width, height)

    # Convert the image to RGB444 format
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

if __name__ == '__main__':
    image_path = 'pics/apple1.jpg'
    save_path = 'codes/coe_files/apple.coe'
    jpg_to_coe(image_path, save_path)
