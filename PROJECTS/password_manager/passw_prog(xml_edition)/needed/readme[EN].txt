Program functions:

✔ access to the program with a master key (eas11)
✔ creation of two types of passwords (random generation and mnemonic)
✔ saving the result of the generation with the login entered from the user in the xml database (encrypted)
✔ manual addition of a login - password link to the database
✔ view existing entries in the database with the option to delete
✔ warning about the passage of a 3-month period of password existence and an indication of the need to change it
✔ regeneration of the encryption method occurs monthly (it is necessary to reset the counter mannually with the update command in the main menu)

Note:
- for the program to work, the "data" folder supplied with it is required in the same directory from which the program is launched
- the range of choosing the length of a random type password from 5 to 35, mnemonic from 2 to 15 words
- "3!6" is added to the end of any mnemonic password for a higher probability of passing the validation check
- in mnemonic generation, the password is formed based on the first two letters of each word from the generated group of words. The first is written as a small register, the second - large
- russian language cannot be encrypted in this version