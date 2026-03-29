/* UART TX address — writing a byte here prints a character */
#define UART_TX (*(volatile unsigned int*)0x10000000)

/* Our own putchar — no libc needed */
void putchar_(char c) {
    UART_TX = c;
}

void print(const char *s) {
    while (*s) putchar_(*s++);
}

void print_int(int n) {
    if (n < 0) { putchar_('-'); n = -n; }
    if (n >= 10) print_int(n / 10);
    putchar_('0' + (n % 10));
}

int main() {
    print("Hello from PicoRV32!\n");

    int sum = 0;
    for (int i = 1; i <= 10; i++) sum += i;

    print("Sum 1..10 = ");
    print_int(sum);
    print("\n");

    return 0;
}