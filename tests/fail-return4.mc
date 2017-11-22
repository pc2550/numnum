void foo()
{
  if (true) return "hello"; /* Should return void */
  else return;
}

int main()
{
  return 42;
}
