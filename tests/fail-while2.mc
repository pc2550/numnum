int main()
{
  int i;

  while (true) {
    i = i + 1;
  }

  while ("hello") { /* Should be boolean */
    i = i + 1;
  }

}
