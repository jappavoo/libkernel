// Absolute
// type a
asm(".set abs_l_foo, 0xdeadbeeffeedface");
// type A
asm(".global abs_g_foo; .set abs_g_foo, 0xdeadbeeffeedface");

// BSS
// type b
static int bss_l_foo;
// type B
int bss_g_foo;

// Data
// type d
static int data_l_foo=0xdeadbeef;
// type D
int data_g_foo=0xdeadbeef;

// Read-only
// type r
static const int ro_l_foo=0xdeadbeef;
// type R
const int ro_g_foo=0xdeadbeef;

// Text
// type t
static void l_text_foo() {}
// type T
void g_test_foo() { }

// weak
// type V
int weak_V_foo __attribute__ ((weak));
// type w
__attribute__((weak)) void weak_w_text(void);
// type W
__attribute__((weak)) void weak_W_text(void) {}

__thread int tint;

int main(){ tint = 0xdeadbeef; weak_w_text(); weak_W_text(); }
