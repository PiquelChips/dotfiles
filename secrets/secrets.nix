let
  # Piquel's personal public key
  piquel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVqRluVYJXXoNYyFQzkZm2v2bRnAv/PNuoLRr2G2/Dv";
  users = [ piquel ];

  nixosbtw = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL2JWt8eVq7rh8Iv41c78xhW3MGKn5m7MBNQ/3iLUWM8";
  piquel-pi = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKtrAhMMQ4WDysvu1zbxrnARtl+B0TwR1ov5MC8Wut0F";
  systems = [
    nixosbtw
    piquel-pi
  ];
in
{
  "psswd.age".publicKeys = [
    piquel
    nixosbtw
  ];
}
