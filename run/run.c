#include<stdio.h>
#include<stdlib.h>
int main(int argc, char** argv){
    if(argc>0){
        system("md out & chcp 65001 & cls");
        printf("nasm assembling...\n");
        char exec[65535];
        sprintf(exec, "nasm -f win64 \"%s.asm\" -o out/\"%s.obj\"", argv[1], argv[1]);
        system(exec);
        printf("GoLink linking...\n");
        //sprintf(exec, "\"C:\\Program Files\\Golink\\Golink.exe\" /console %s.obj msvcrt.dll", argv[1]);
        sprintf(exec, "cd out & golink /console %s.obj msvcrt.dll", argv[1]);
        system(exec);
        printf("\n-----------------------------------------\n\n");
        sprintf(exec, "cd out & \"%s.exe\"", argv[1]);
        system(exec);
    }else{
        printf("參數！我要參數！");
    }
    printf("\n\n-----------------------------------------\n");
    system("pause");
    return 0;
}
