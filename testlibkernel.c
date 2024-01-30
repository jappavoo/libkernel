extern void ksys_write(void);
extern __thread unsigned long long current_task;
int main() {
  current_task ++;
  ksys_write();
  return 0;
}
