#!/usr/bin/env python
# coding: utf-8

# <a href="https://colab.research.google.com/github/KatrinaJMD/IronHack_GitHub/blob/main/%5BPROJECT01%5D_Risk.ipynb" target="_parent"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab"/></a>

# ## PSEUDOCODE

# ## Code

# In[2]:


def risk():
    import random

    a = int(input("No. of armies to deploy: "))

    a = a
    d = a
    x = a

    while (a != 0) or (d != 0):

        lst_a = []
        lst_d = []      

        for i in range(a):
            lst_a.append(random.randrange(1, 11))
        for i in range(d):
            lst_d.append(random.randrange(1, 11))     

        lst_a.sort(reverse=True)
        lst_d.sort(reverse=True)        

        print("\n")
        print(f"Attacker = {lst_a}")
        print(f"Defender = {lst_d}")     

        loss_a = 0
        loss_d = 0      


        for i in range(x):
            if lst_a[i] > lst_d[i]:
                loss_d += 1
            elif lst_a[i] < lst_d[i]:
                loss_a += 1
            elif lst_a[i] == lst_d[i]:
                loss_a += 1  


        a_remain = len(lst_a) - loss_a
        d_remain = len(lst_d) - loss_d  
        
        if a_remain >= d_remain:
            x = d_remain
        elif a_remain < d_remain:
            x = a_remain

        print("\n")
        print(f"Attacker lost {loss_a} armies, {a_remain} armies left.")
        print(f"Defender lost {loss_d} armies, {d_remain} armies left.")  
              
        print("\n")
        if a_remain == 0:
            print("DEFENDER WINS!!!")
            break
        elif d_remain == 0:
            print("ATTACKER WINS!!!")
            break   

        a = a_remain
        d = d_remain    
            
        print("-" * 50)

risk()

