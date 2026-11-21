import sys

# ---------- Tables ----------
COMP = {
    '0': '0101010', '1': '0111111', '-1': '0111010',
    'D': '0001100', 'A': '0110000', '!D': '0001101', '!A': '0110001',
    '-D': '0001111', '-A': '0110011', 'D+1': '0011111', 'A+1': '0110111',
    'D-1': '0001110', 'A-1': '0110010', 'D+A': '0000010', 'D-A': '0010011',
    'A-D': '0000111', 'D&A': '0000000', 'D|A': '0010101',
    'M': '1110000', '!M': '1110001', '-M': '1110011', 'M+1': '1110111',
    'M-1': '1110010', 'D+M': '1000010', 'D-M': '1010011', 'M-D': '1000111',
    'D&M': '1000000', 'D|M': '1010101',
}
DEST = {'': '000', 'M': '001', 'D': '010', 'MD': '011',
        'A': '100', 'AM': '101', 'AD': '110', 'AMD': '111'}
JUMP = {'': '000', 'JGT': '001', 'JEQ': '010', 'JGE': '011',
        'JLT': '100', 'JNE': '101', 'JLE': '110', 'JMP': '111'}


def predefined_symbols():
    table = {'SP': 0, 'LCL': 1, 'ARG': 2, 'THIS': 3, 'THAT': 4,
             'SCREEN': 16384, 'KBD': 24576}
    for i in range(16):
        table['R' + str(i)] = i
    return table


def clean(raw):
    # comment hatao aur saare spaces/tabs hatao
    return ''.join(raw.split('//')[0].split())


def a_instruction(text, symbols, next_var):
    value = text[1:]
    if value == '':
        raise ValueError('invalid instruction: nothing after "@"')
    if value.isdigit():
        number = int(value)
        if number > 32767:
            raise ValueError('invalid instruction: number is bigger than 32767')
    else:
        if value[0].isdigit():
            raise ValueError('invalid instruction: symbol cannot start with a digit')
        if value not in symbols:
            symbols[value] = next_var   # naya variable
            next_var += 1
        number = symbols[value]
    return format(number, '016b'), next_var


def c_instruction(text):
    dest, comp, jump = '', text, ''
    if '=' in comp:
        dest, comp = comp.split('=', 1)
    if ';' in comp:
        comp, jump = comp.split(';', 1)
    if dest not in DEST:
        raise ValueError(f'invalid instruction: unknown dest "{dest}"')
    if comp not in COMP:
        raise ValueError(f'invalid instruction: unknown comp "{comp}"')
    if jump not in JUMP:
        raise ValueError(f'invalid instruction: unknown jump "{jump}"')
    return '111' + COMP[comp] + DEST[dest] + JUMP[jump]


def assemble(in_path, out_path):
    symbols = predefined_symbols()
    errors = 0

    # ----- Pehla reading: labels ka address -----
    code_lines = []          # (original line number, text)
    pc = 0
    with open(in_path) as f:
        for line_no, raw in enumerate(f, start=1):
            text = clean(raw)
            if text == '':
                continue
            if text.startswith('('):
                if text.endswith(')') and len(text) > 2:
                    symbols[text[1:-1]] = pc
                else:
                    print(f'Line {line_no}: invalid label')
                    errors += 1
            else:
                code_lines.append((line_no, text))
                pc += 1

    # ----- Doosra reading: 16 bits banao -----
    next_var = 16
    output = []
    for line_no, text in code_lines:
        try:
            if text.startswith('@'):
                bits, next_var = a_instruction(text, symbols, next_var)
            else:
                bits = c_instruction(text)
            output.append(bits)
        except ValueError as e:
            print(f'Line {line_no}: {e}')   # K=13 feature: crash nahi, message
            errors += 1

    if errors:
        print(f'{errors} error(s) found. {out_path} was not written.')
        return
    with open(out_path, 'w') as f:
        f.write('\n'.join(output) + '\n')
    print(f'Done: {out_path} ({len(output)} instructions)')


if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Use: python3 assembler.py File.asm [Output.hack]')
        sys.exit(1)
    in_path = sys.argv[1]
    out_path = sys.argv[2] if len(sys.argv) > 2 else in_path.rsplit('.', 1)[0] + '.hack'
    try:
        assemble(in_path, out_path)
    except FileNotFoundError:
        print(f'File not found: {in_path}')

