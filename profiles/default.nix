{ profile, ... }:
{
  imports = [
    ./common
    ./${profile}
  ];
}