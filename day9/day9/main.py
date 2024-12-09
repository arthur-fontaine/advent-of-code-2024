
import logging
from typing import List, Callable, Optional, TypeVar

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
            number_of_dots = int(char)
            if number_of_dots == 0:
                continue
            r += ['.' * int(char)]
    return r

def rearange_blocks(blocks: List[str]):
    r = list(blocks)
    free_space_index = 0
    i = len(r) - 1
    while i > 0:
        if r[i][0] == '.':
            i -= 1
            continue
        group_length = get_group_length(r, i)
        free_space_index_ = index_fn(r, lambda x: x[0] == '.' and len(x) >= group_length, 0, i)
        if free_space_index_ != -1:
            free_space_index = free_space_index_
            free_space = r[free_space_index]
            free_space_filler = r[i-group_length+1:i+1]
            diff = len(r[free_space_index]) - group_length
            if diff > 0:
                free_space_filler += ['.' * diff]
            r[i-group_length+1:i+1] = ['.' * group_length]
            r[free_space_index:free_space_index+1] = free_space_filler
            i += len(free_space) - diff
        i -= group_length
    return r

T = TypeVar('T')
def index_fn(arr: List[T], fn : Callable[[T], bool], start: int = 0, end: Optional[int] = None):
    if end is None:
        end = len(arr)
    for i in range(start, end, -1 if start > end else 1):
        if fn(arr[i]):
            return i
    return -1

def get_group_length(blocks: List[str], block_index: int):
    block = blocks[block_index]
    for i in range(block_index, 0, -1):
        if blocks[i] != block:
            return block_index - i
    return i

def calculate_sum(blocks: List[str]):
    r = 0
    i = 0
    m = 0
    while i < len(blocks):
        char = blocks[i]
        if char[0] == '.':
            m += len(char)
            i += 1
            continue
        r += int(char) * m
        i += 1
        m += 1
    return r

def main():
    logging.info('Starting main function')
    logging.info('Reading input')
    input = read_input()
    logging.info('Generating blocks')
    blocks = generate_blocks(input)
    logging.info('Rearanging blocks')
    rearranged_blocks = rearange_blocks(blocks)
    logging.info('Calculating sum')
    s = calculate_sum(rearranged_blocks)
    print(s)

if __name__ == '__main__':
    main()
