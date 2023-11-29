# Euro PLN exchange
"""
Created on Wed Nov 29 09:40:36 2023

@author: jmarb
"""

def change_PLN_to_Euros(PLN):
    return PLN/4.4

def change_Euros_to_PLN(Euros):
    return Euros*4.4

while True:
    print("""\t.:MENU:.
1. Change PLN to euros
2. Change euros to PLN 
3. Exit""")
    opcion = int(input("Enter an opcion: "))
    
    print()

    if opcion == 1:
        PLN = float(input("Enter PLN to change: "))
        print(f"PLN -> Euros {change_PLN_to_Euros(PLN):.2f}")
        
    elif opcion ==2:
        Euros = float(input("Enter Euros to change: "))
        print(f"Euros -> PLN {change_Euros_to_PLN(Euros):.2f}")
        
    elif opcion==3:
        break
    
    else: 
        print("Please, choose a right option.")
        
    print()    
    
        
