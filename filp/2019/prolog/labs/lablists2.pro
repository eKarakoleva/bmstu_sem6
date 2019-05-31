DOMAINS
	int_list = integer*

PREDICATES
	lengthtr(int_list, integer, integer)
	length(int_list, integer)
	sumtr(int_list, integer, integer)
	removeone(int_list,integer,int_list)
	removebypos(int_list,integer,int_list)
	removeMember(int_list,integer,int_list)
	removeMoreThen(int_list,integer,int_list)
	removeEvenPos(int_list,integer,int_list)
	mergelist(int_list,int_list,int_list )
	member1(integer,int_list)
	listtoset(int_list,int_list)
	
CLAUSES

	
	lengthtr([],M,M).
	lengthtr([_|T],M, R):- M1=M+1, lengthtr(T,M1,R).
	
	length([],0).
	length([_|T],L):-length(T,L1), L=L1+1.
	
	sumtr([],M,M).
	sumtr([H|T],M,R):- M1=M+H, sumtr(T,M1,R).
	
	removeone([X|Tail],X,Tail).
	removeone([Y|Tail],X,[Y|Tail1]):- removeone(Tail,X,Tail1).	
	
	removebypos([_|T],0, T).
	removebypos([H|T], POS, [H|Z]):- POS1=POS-1, removebypos(T,POS1,Z).
	
	removeMember([],_,[]) :- !.
	removeMember([X|Xs], X, Y) :- !, removeMember(Xs, X, Y).
	removeMember([T|Xs], X, [T|Y]) :- removeMember(Xs, X, Y).
	
	removeMoreThen([],_,[]) :- !.	
	removeMoreThen([H|T],X, PTail):- H > X, !, removeMoreThen(T,X, PTail).
  	removeMoreThen([H|T],X, [H|PTail]):- removeMoreThen(T,X, PTail).
	
	
	removeEvenPos([],_,[]) :- !.	
	removeEvenPos([_|T], POS, PTail):- POS1=POS+1, POS mod 2 = 1,!,removeEvenPos(T,POS1, PTail).
	removeEvenPos([H|T], POS, [H|L]):- POS1=POS+1, removeEvenPos(T ,POS1, L).
	
	mergelist([],L,L ).
	mergelist([H|T],L,[H|M]):-mergelist(T,L,M).

	member1(X,[H|_]) :- X = H,!.
	member1(X,[_|T]) :- member1(X,T).
 
	listtoset([],[]).
	listtoset([H|T],C) :- member1(H,T),!, listtoset(T,C).
	listtoset([H|T],[H|C]) :- listtoset(T,C).
GOAL
	%lengthtr([1,2,3,4,5],0,R).
	%length([1,2,3,4,5],Z).
	%sumtr([1,2,3,4,5],0,R).
	%removeone([1,2,3,4,5],3,R).
	%removeone([1,3,2,3,5],3,R).
	%removeone([1,3,2,3,5],1,R).
	%removeone([1,3,2,3,5],5,R).
	%removebypos([0,1,2,3,4,5], 2,X).
	%removebypos([0,1,2,3,4,5], 0,X).
	%removebypos([0,1,2,3,4,5], 5,X).
	%removeMember([0,1,2,3,4,5],2, X).
	%removeMember([1,3,2,3,5],3, X).
	%removeMember([0,1,2,3,4,5],6,X).
	%removeMoreThen([1,3,2,3,5],2, X).
	%removeMoreThen([1,3,2,3,5],3, X).
	%removeEvenPos([1,3,2,3,5],0, X).
	mergelist([1,2],[3,4,5],M).
	%listtoset([1,2,3,2,4,2,5],M).
	