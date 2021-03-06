/*
 *
 * Author: T&M
 */
#include <glcd.h>
#include <font5x7.h>
#include <mega32a.h>
#include <delay.h>

int turn = 0; // 0 -> X , 1 -> O;
int table[3][3];                                                                                                                          
int c_end = 0;
int p1=0;
int p2=0;
int round = 0;



void config_LCD(){
    GLCDINIT_t glcd_init_data;
    glcd_init_data.font=font5x7;
    glcd_init(&glcd_init_data);   
}

void config_Ports(){
    DDRC = 0x00;
    PORTC = 0xFF;
    DDRD = 0x00;
    PORTD = 0xFF;
}

void reset(){ 

    int i,j;
    c_end = 0 ;
    p1 = 0;
    p2 = 0;
    round = 1;


    glcd_clear();
    
    
    
    //Shapes!
    glcd_line(21,0,21,63);
    glcd_line(0,21,63,21);
    glcd_line(42,0,42,63);
    glcd_line(0,42,63,42);
    
    glcd_outtextxyf(80,0,"P1");
    glcd_outtextxyf(80,10,"0");
    glcd_outtextxyf(100,0,"P2");
    glcd_outtextxyf(100,10,"0");
    glcd_outtextxyf(120,0,"R");
    glcd_outtextxyf(120,10,"1");
    
    glcd_outtextxyf(80,20,"Turn: ");
    
    if(turn==0){
    glcd_outtextxyf(110,20,"X");
    }
    else{
    glcd_outtextxyf(110,20,"O");
    }
     
    
    // clear table
    for(i=0;i<3;i++){
    for(j=0;j<3;j++){
        table[i][j] = 2 ;
        }
    } 
    
    glcd_outtextxyf(70,56,"XO by T&M");
}

void reset_without_Button(){ 

    int i,j;
    c_end = 0 ;
    //turn=0;
                   
    if (round <=5){
        round += 1;
        
            glcd_clear();
    
            glcd_outtextxyf(80,0,"P1");
            glcd_outtextxyf(100,0,"P2");
            glcd_outtextxyf(120,0,"R");
            
            
            
            glcd_line(21,0,21,63);
            glcd_line(0,21,63,21);
            glcd_line(42,0,42,63);
            glcd_line(0,42,63,42);
            
            glcd_outtextxyf(80,20,"Turn: ");
            
            if(turn==0){
            glcd_outtextxyf(110,20,"X");
            }
            else{
            glcd_outtextxyf(110,20,"O");
            } 
            
    // clear table
    for(i=0;i<3;i++){
    for(j=0;j<3;j++){
        table[i][j] = 2 ;
        }
    } 
    
    glcd_outtextxyf(70,56,"XO by T&M");
                   
    } 
    

        
        
    if(round == 6){
        if(p1>p2){
            glcd_clear();
            glcd_outtextxyf(20,32,"Player 1 Wins !");
            delay_ms(2000);
        }
        if(p1<p2){
            glcd_clear();
            glcd_outtextxyf(20,32,"Player 2 Wins !");
            delay_ms(2000);
        }                                  
        if(p1==p2) {
            glcd_clear();
            glcd_outtextxyf(50,32,"! Draw !");
            delay_ms(2000); 
        }
         
        reset();
    }
    
 

    
}

void scores(char winner)
{
    if(winner == 'X'){
        p1 += 1 ;
    }
    if(winner == 'O'){
        p2 += 1 ;
    }
    

    reset_without_Button();

    
    switch (p1) {
    case 0: 
            glcd_outtextxyf(80,10,"0");   
    break;
    
    case 1:
            glcd_outtextxyf(80,10,"1");   
    break;
    case 2:
            glcd_outtextxyf(80,10,"2");   
    break;
    case 3:
            glcd_outtextxyf(80,10,"3");   
    break;
    case 4:
            glcd_outtextxyf(80,10,"4");   
    break;                             
    }; 
    
    switch (p2) {
    case 0: 
            glcd_outtextxyf(100,10,"0");   
    break;
    
    case 1:
            glcd_outtextxyf(100,10,"1");   
    break;
    case 2:
            glcd_outtextxyf(100,10,"2");   
    break;
    case 3:
            glcd_outtextxyf(100,10,"3");   
    break;
    case 4:
            glcd_outtextxyf(100,10,"4");   
    break;                             
    };
    
        
    switch(round) {
    case 1: 
            glcd_outtextxyf(120,10,"1");   
    break;
    
    case 2:
            glcd_outtextxyf(120,10,"2");   
    break;
    case 3:
            glcd_outtextxyf(120,10,"3");   
    break;
    case 4:
            glcd_outtextxyf(120,10,"4");   
    break;
    case 5:
            glcd_outtextxyf(120,10,"5");   
    break;
                                 
    }; 
    
    

    
}

void draw_winner_line(int x1, int y1, int x2, int y2)
{
    glcd_line(x1,y1,x2,y2);    
}

void check_win(int t[3][3]){
    if((t[2][2]== 0 && t[0][0]==0 && t[1][1]== 0) || (t[2][2]==1 && t[0][0]==1 && t[1][1]==1) )
   {
        draw_winner_line(8,8,55,55);
        delay_ms(500);
        glcd_clear();
        if(turn==0){
              glcd_outtextxyf(50,32,"O wins!");
              scores('O');
              delay_ms(500);
              //reset_without_Button();
        }
        else{
        glcd_outtextxyf(50,32,"X win");
        scores('X');
        delay_ms(500);
        //reset_without_Button();            
        }
   }
   
   
   if((t[0][2]== 0 && t[0][0]==0 && t[0][1]== 0) || (t[0][2]==1 && t[0][0]==1 && t[0][1]==1))
   {   
        draw_winner_line(10,10,55,10);
        delay_ms(500);
        glcd_clear();
        if(turn==0){
              glcd_outtextxyf(50,32,"O wins!");
              scores('O');
        delay_ms(500);
        //reset();
        }
        else{
        glcd_outtextxyf(50,32,"X win");
        scores('X');
        delay_ms(500);
        //reset();
        }
   
   }
   
   
   if((t[2][0]== 0 && t[1][0]==0 && t[0][0]== 0) || (t[2][0]==1 && t[1][0]==1 && t[0][0]==1)) 
   {
        draw_winner_line(8,8,8,55);
        delay_ms(500);
        glcd_clear();
        if(turn==0){
        glcd_outtextxyf(50,32,"O wins!");
        scores('O');
        delay_ms(500);
        //reset();
        }
        else{
        glcd_outtextxyf(50,32,"X win");
        scores('X');
        delay_ms(500);
        //reset();
        }

   }
   
   

   
   if(t[1][0]==t[1][1] && t[1][1]==t[1][2]) 
   {              
        if(t[1][0]!= 2)
        {
            draw_winner_line(8,32,55,32);                         
            delay_ms(500);
            glcd_clear();
            if(turn==0){
                  glcd_outtextxyf(50,32,"O wins!");
            scores('O');
            delay_ms(500);
            //reset();
            }
            else{
            glcd_outtextxyf(50,32,"X win");
            scores('X');
            delay_ms(500);
            //reset();
            }
        }
   }
   
   
   if(t[2][0]==t[2][1] && t[2][1]==t[2][2]) 
   {
        if(t[2][0]!= 2)
        {                  
            draw_winner_line(8,55,55,55);
            delay_ms(500);
            glcd_clear();
            if(turn==0){
            glcd_outtextxyf(50,32,"O wins!");
            scores('O');
            delay_ms(500);
            //reset();
            }
            else{
            glcd_outtextxyf(50,32,"X win");
            scores('X');
            delay_ms(500);
            //reset();
            }
        }
   }
   
   
   if(t[0][1]==t[1][1] && t[1][1]==t[2][1]) 
   {
        if(t[0][1]!= 2)
        {                   
            draw_winner_line(32,8,32,55);
            delay_ms(500);
            glcd_clear();
            if(turn==0){
            glcd_outtextxyf(50,32,"O wins!");
            scores('O');
            delay_ms(500);
            //reset();
            }
            else{
            glcd_outtextxyf(50,32,"X win");
            scores('X');
            delay_ms(500);
            //reset();
            }
        }
   }
   
   
   if(t[0][2]==t[1][2] && t[1][2]==t[2][2])
   {
        if(t[0][2]!= 2)
        {                  
            draw_winner_line(55,8,55,55);
            delay_ms(500);
            glcd_clear();
            if(turn==0){
            glcd_outtextxyf(50,32,"O wins!");
            scores('O');
            delay_ms(500);
            //reset();
            }
            else{
            glcd_outtextxyf(50,32,"X win");
            scores('X');
            delay_ms(500);
            //reset();
            }
        }
   }
   
   
   if(t[0][2]==t[1][1] && t[1][1]==t[2][0])
   {                                         
        
        if(t[0][2]!= 2)
        {                           
            draw_winner_line(55,8,8,55);
            delay_ms(500);
            glcd_clear();
            if(turn==0){
            glcd_outtextxyf(50,32,"O wins!");
            scores('O');
            delay_ms(500);
            //reset();
            }
            else{
            glcd_outtextxyf(50,32,"X win");
            scores('X');
            delay_ms(500);
            //reset();
            }
        }
   }   
}

void newInput(int table[3][3],int i1, int i2 ){
    if(i1 != 255 ){
        if(i1 == 254) // Button 0,0
        {
            if(table[0][0]== 2)
            {
             table[0][0] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(10,10,"X");//write input           
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(10,10,"O");//write input
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             } 
             c_end += 1;               
            }       
        }     // end Button
        
        if(i1 == 253) // Button 0,1
        {
            if(table[0][1]== 2)
            {
             table[0][1] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(31,10,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(31,10,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button 
        
        
        if(i1 == 251) // Button 0,2
        {
            if(table[0][2]== 2)
            {
             table[0][2] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(52,10,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(52,10,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button
        
        
        if(i1 == 247) // Button 1,0
        {
            if(table[1][0]== 2)
            {
             table[1][0] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(10,32,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(10,32,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button
        
        
        
        if(i1 == 239) // Button 1,1
        {
            if(table[1][1]== 2)
            {
             table[1][1] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(32,32,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(32,32,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button 
        
        
        if(i1 == 223) // Button 1,2
        {
            if(table[1][2]== 2)
            {
             table[1][2] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(53,32,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(53,32,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button
                                 
        
        
        if(i1 == 191) // Button 2,0
        {
            if(table[2][0]== 2)
            {
             table[2][0] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(10,52,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(10,52,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button
    
                                    
        
        if(i1 == 127) // Button 2,1
        {
            if(table[2][1]== 2)
            {
             table[2][1] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(32,52,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(32,52,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button
       
    
    }   // end of portC
    
         
    if(i2 != 255 ){   
    
        if(i2 == 254) // Button 2,2
        {
            if(table[2][2]== 2)
            {
             table[2][2] = turn; 
             
             if(turn==0){
                glcd_outtextxyf(52,52,"X"); 
                glcd_outtextxyf(110,20,"O");// write turn

                delay_ms(500);
             }
             else{
                glcd_outtextxyf(52,52,"O");
                glcd_outtextxyf(110,20,"X");// write turn
                delay_ms(500);                
             }             
             if(turn==0){
                turn = 1;
             }
             else{
                turn = 0;
             }
             c_end += 1;                
            }       
        }     // end Button 
        
        
        if(i2 == 253) // Button reset
        {
            reset();                  
        }     // end Button    
    }
    check_win(table);
}

void main(void)
{

int input1,input2;

    
config_LCD();
config_Ports();

while (1)
    {    
    reset();
    
    while(c_end<= 9){
             
        input1 = PINC;
        input2 = PIND;
        
        if(input1!=255 || input2 !=255){
            newInput(table,input1 , input2 );               
        }        
                
        if(c_end == 9)
        {                      
            glcd_clear();
            //glcd_outtextxyf(10,32,"!!! PLAY AGAIN !!!");
            scores('');
            delay_ms(1000);

        }        
}
}
}