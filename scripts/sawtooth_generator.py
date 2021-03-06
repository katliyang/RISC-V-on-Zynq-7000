import math
def twos_comp(val, bits):
    if (val < 0):
        val = (1 << bits) + val
    return val

with open ('sawtooth_lut.hex', 'w') as f:
    for i in range(0, 256):
        print(int(((i + 0.5)/256*32768)))
        f.write('{:x}'.format(twos_comp(int((i/256*32768)), 21)) + "\n")
