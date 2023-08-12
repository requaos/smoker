{
  inputs,
  cell,
}: {
  # make xdg links work correctly.
  # enable = true;
  mimeApps = {
    enable = true;
    defaultApplications = {
      "scheme-handler/http" = "google-chrome.desktop";
      "scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/http" = "google-chrome.desktop";
      "x-scheme-handler/https" = "google-chrome.desktop";
      "x-scheme-handler/about" = "google-chrome.desktop";
      "x-scheme-handler/unknown" = "google-chrome.desktop";
      "x-scheme-handler/notion" = "notion-app-enhanced.desktop";
      "text/html" = "google-chrome.desktop";
      "application/pdf" = "google-chrome.desktop";
    };
  };
}
