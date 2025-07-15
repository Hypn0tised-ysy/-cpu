#pragma GCC push_options
#pragma GCC optimize("O0")

void start() {
  asm("li\tsp,1024\n\t"
      "call main");
}
__attribute__((noinline)) void wait(int instr_num) {
  while (instr_num--)
    ;
}

void terminate_overflow(void) {
  while (1) {
    (*(int *)0xE0000000) = 0x77777777;
    // 灯全亮
    (*(short *)0xF0000000) = 0xFFFF;
  }
}
void terminate_undefined_instruction(void) {
  // sw12 未定义操作码
  while (1) {
    (*(int *)0xE0000000) = 0x99999999;
    // 灯全亮
    (*(short *)0xF0000000) = 0xFFFF;
  }
}

void interrupt_handler(void) {
  // sw15 算术中断
  if (((*(int *)0xF0000000) >> 15) & 1) {
    terminate_overflow();
  }

  // sw14 外部中断
  else if (((*(int *)0xF0000000) >> 14) & 1) {
    while (((*(int *)0xF0000000) >> 14) & 1) {
      // 灯全亮
      (*(short *)0xF0000000) = 0xFFFF;
    }
    // ERETN
    (*(short *)0xF0000000) = 0x0000;
    asm volatile(".word 0x11111111");
  }

  // sw13 系统调用
  else if (((*(int *)0xF0000000) >> 13) & 1) {
    //
    int i = 3;
    int mask = 0xaaaa;
    while (i--) {
      (*(short *)0xF0000000) = mask;
      mask >>= 4;
    }
    // ERETN
    (*(short *)0xF0000000) = 0x0000;
    asm volatile(".word 0x11111111");
  }

  // sw12 未定义操作码
  else if (((*(int *)0xF0000000) >> 12) & 1) {
    terminate_undefined_instruction();
  }
}
void main() {

  //   int x = 0x39C5BB00;
  //   (*((int *)0xE0000000)) = x;
  //   while (1) {
  //     wait(1000000);
  //     x = x ^ 0x39C5BB00 ^ 0x66CCFF00;
  //     (*((int *)0xE0000000)) = x;
  //   }
  // sw15 算术中断
  if (((*(int *)0xF0000000) >> 15) & 1) {
    volatile int a = 0x7FFFFFFF;
    volatile int b = 0x7FFFFFFF;
    // 计算c会触发溢出中断
    int c = a + b;
  }

  // sw14 外部中断
  else if (((*(int *)0xF0000000) >> 14) & 1) {
    interrupt_handler();
  }

  // sw13 系统调用
  else if (((*(int *)0xF0000000) >> 13) & 1) {
    // syscall
    asm volatile(".word 0x00111111");
  }

  // sw12 未定义操作码
  else if (((*(int *)0xF0000000) >> 12) & 1) {
    // undefined instruction
    asm volatile(".word 0x11110000");
  }

  int disp_num = 0x20250715;
  int seg_addr_write = 0xE0000000;
  int led_addr_write = 0xF0000000;
  int sw_addr_read = 0xF0000000;
  (*(int *)0xE0000000) = disp_num;

  // int sw_i[16]; // 每次要用的时候重新赋值
  // for (int i = 0; i < 16; i++) {
  //   sw_i[i] = ((*(int *)0xF0000000) >> i) & 1;
  // }

  while (1) {
    (*(int *)0xE0000000) = disp_num;
  }
}
#pragma GCC pop_options