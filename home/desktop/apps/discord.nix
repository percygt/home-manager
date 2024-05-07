{config, ...}: {
  programs.firefox.webapps.discord = {
    enable = true;

    url = "https://discord.com";
    id = 1;

    extraSettings = config.programs.firefox.profiles."home".settings;
    backgroundColor = "#202225";

    comment = "All-in-one voice and text chat for gamers that's free, secure, and works on both your desktop and phone.";
    genericName = "Internet Messenger";
    categories = [
      "Network"
      "InstantMessaging"
    ];
  };
}
