from PIL import Image
import sys

def hex_to_rgb(value: str):
    value = value.lstrip('#')
    lv = len(value)
    return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))
def rgb_to_hex(rgb: tuple[int, int, int]):
    return "#%02x%02x%02x" % rgb

def safe_get_pal(pal: dict[str, str], value: str):
    if value in pal:
        return pal[value]
    else:
        return None

def find_first_match(pal: dict[str, str], value: str):
    for possible_match in pal:
        if possible_match == value:
            return pal[possible_match]
    return "0xFF"

pal = {}

with open(sys.argv[1]) as palette:
    palette = palette.readlines()
    for index, line in enumerate(palette):
        if not f"#{line[:-1]}" in pal:
            pal[f"#{line[:-1]}"] = str(hex(index))[0:2] + str(hex(index))[2:].upper().rjust(2, "0")

output = "image:\n"

with Image.open(sys.argv[2]) as image:
    width, height = image.size
    for y in range(height):
        output += "    db "
        for x in range(width):
            output += f"{find_first_match(pal, rgb_to_hex(image.getpixel((x, y))[0:3]))}, "
        output = output[:-2] + "\n"

with open(sys.argv[3], "w") as outfile:
    outfile.write(output)