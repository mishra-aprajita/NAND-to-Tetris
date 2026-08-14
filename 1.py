def sum_of_digits(num):
    
    num_str = str(num)
    
    total = 0
    
    for digit in num_str:
        total += int(digit)
    
    return total