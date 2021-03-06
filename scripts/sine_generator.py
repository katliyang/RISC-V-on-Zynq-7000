import math
def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val

with open ('sine_lut.hex', 'w') as f:
    for i in range(0, 256):
        print(int(math.sin(2*math.pi*(i + 0.5)/1024)*65536))
        f.write('{:x}'.format(twos_comp(int(math.sin(2*math.pi*i/1024)*65536), 21)) + "\n")
