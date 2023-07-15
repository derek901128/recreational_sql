I love SQL. For the longest time I almost only write it at work, but playing with Advent of Code made me wanna do even more things with it. Hence I created this repo, a collection of SQL pieces with which I attempt to explore SQL, to explore myself, to have fun.

1. Tic Tac Toe
   -> All the moves are randomized each time the query is run, hence the result will be different each time.
   -> The moves the randomized in the sense that they're not made not based on the state of the game, but purely on randomization. It means that you
      can see the players do stupid things. My hope is to implememnt some rudimentary strategies in one of the players, see if some more sophisticated       algo can be implemented down the line.
2. Random Walker
   -> While the logic of a Random Walker is pretty straight forward, one thing that I havent implemented but really want is the ability for the walker       to change its course if the current move will lead it back to place that it has been.
3. Number to Binary
   -> Been reading up on bitwise operations in SQL, then came across this procedure someone wrote to convert number to binary. Me being me, of course        I need to implement the same logic into one single pure SQL query. 
4. Reverse Number
   -> Once I was brave enough to tackle Haskell, only to be completely overwhelemed by this number-reversing problem. Consider this a reclaim of my          manhood.
5. Reverse Number - LeetCode
   ->  I was never into LeetCode, but when I stumbled upone this question, immediately I saw two things: recursiver queries and bit conversion. I             first implement each one seperatly, then here I put them together in one cohesive query that first reverse then input number, convert it into          binary and count the number of bits, finally using a case when to decide whether the reversed number is overflowing or not. Frankly I'm 
         quite happy with what I got here. 
6. Random String generation
   -> Nothing spectacular here, just generating random ascii values from 97 to 122, and convert them back into letters. 
7. Handrolled Aggregates
   -> Since these days I'm hanging around in the Recursion Land quite a bit, I think to myself: why don't I just make my life harder by       handrolling my own aggregate functions that don't work with group by clause ? Sounds like real computer science to me ! 
