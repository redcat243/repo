#include <iostream>
#include <string>
#include <unistd.h>
#include <limits.h>
#include <stdlib.h>
#include <string.h>

// Include C++ headers first, then define and include the webview library
#define WEBVIEW_IMPLEMENTATION
#define WEBVIEW_GTK
#include "webview.h"

std::string get_executable_dir() {
    char result[PATH_MAX];
    ssize_t count = readlink("/proc/self/exe", result, PATH_MAX);
    if (count != -1) {
        std::string fullPath(result, count);
        size_t lastSlash = fullPath.find_last_of("/");
        if (lastSlash != std::string::npos) {
            return fullPath.substr(0, lastSlash);
        }
    }
    return ".";
}

void show_about(const std::string& exeDir) {
    std::string aboutPath = exeDir + "/about.rtfd/sammy.png";
    std::string cmd = "xdg-open \"file://" + aboutPath + "\"";
    int result = system(cmd.c_str());
    (void)result;
}

int main() {
    std::string exeDir = get_executable_dir();
    std::string homePath = "file://" + exeDir + "/cathome.html";
    
    struct webview w;
    memset(&w, 0, sizeof(w));
    
    w.title = "CatBrowser - better for your computer";
    w.width = 1200;
    w.height = 800;
    w.resizable = 1;
    w.url = homePath.c_str();

    if (webview_init(&w) != 0) return 1;

    std::string js = "window.oncontextmenu=function(e){e.preventDefault();"
                     "var c=prompt('1:HOME, 2:GOOGLE, 3:OIIA, 4:BACK');"
                     "if(c=='1')location.href='"+homePath+"';"
                     "if(c=='2')location.href='https://google.com';"
                     "if(c=='3')location.href='https://www.youtube.com/watch?v=r7-K-Z_H0mU';"
                     "if(c=='4')history.back();};";
    webview_eval(&w, js.c_str());

    while (webview_loop(&w, 1) == 0) {}
    
    webview_exit(&w);
    return 0;
}
