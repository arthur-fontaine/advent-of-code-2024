import logging
from typing import List

logging.basicConfig(level=logging.DEBUG)

def read_input():
    with open('input.txt', 'r') as f:
        return f.read().strip()

def generate_blocks(line: str):
    r: list[str] = []
    for i, char in enumerate(line):
        if i % 2 == 0:
            r += [str(i // 2)]  * int(char)
        else:
            r += ['.']  * int(char)
    return r

def rearange_blocks(blocks: List[str]):
    r = list(blocks)
    logging.debug(f'Blocks length: {len(blocks)}')
    first_dot_index = 0
    for i in range(len(blocks) - 1, 0, -1):
        try:
            first_dot_index = r.index('.', first_dot_index, i)
        except ValueError:
            break
        r[i], r[first_dot_index] = r[first_dot_index], r[i]
    return r

def calculate_sum(blocks: List[str]):
    r = 0
    for i, char in enumerate(blocks):
        if char == '.':
            break
        r += int(char) * i
        # logging.debug(f'Adding {int(char)} * {i} = {int(char) * i} (total: {r})')
    return r

def main():
    logging.info('Starting main function')
    logging.info('Reading input')
    input = read_input()
    logging.info('Generating blocks')
    blocks = generate_blocks(input)
    with open('debug.log', 'w') as f:
        f.write(str(blocks))
    logging.info('Rearanging blocks')
    rearranged_blocks = rearange_blocks(blocks)
    with open('debug2.log', 'w') as f:
        f.write(str(rearranged_blocks))
    logging.info('Calculating sum')
    s = calculate_sum(rearranged_blocks)
    print(s)

if __name__ == '__main__':
    main()
