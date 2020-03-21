%***************************
% TP IA N°1 
% Yanis Imekraz - Jonathan Andrieu 
% 4IR-C2
%***************************

%***************************
%DESCRIPTION DU JEU DU TAKIN
%***************************

   %********************
   % ETAT INITIAL DU JEU
   %********************   
   % format :  initial_state(+State) ou State est une matrice (liste de listes)
   

initial_state([ [b, h, c],       % C'EST L'EXEMPLE PRIS EN COURS
                [a, f, d],       %
                [g,vide,e] ]).   % h1=4,   h2=5,   f*=5



% AUTRES EXEMPLES POUR LES TESTS DE  A*

/*
initial_state([ [ a, b, c],        
                [ g, h, d],
                [vide,f, e] ]). % h2=2, f*=2
initial_state([ [b, c, d],
                [a,vide,g],
                [f, h, e]  ]). % h2=10 f*=10
            
initial_state([ [f, g, a],
                [h,vide,b],
                [d, c, e]  ]). % h2=16, f*=20
            
initial_state([ [e, f, g],
                [d,vide,h],
                [c, b, a]  ]). % h2=24, f*=30
initial_state([ [a, b, c],
                [g,vide,d],
                [h, f, e]]). % etat non connexe avec l'etat final (PAS DE SOLUTION)
*/  


   %******************
   % ETAT FINAL DU JEU
   %******************
   % format :  final_state(+State) ou State est une matrice (liste de listes)
   
final_state([[a, b,  c],
             [h,vide, d],
             [g, f,  e]]).

            
   %********************
   % AFFICHAGE D'UN ETAT
   %********************
   % format :  write_state(?State) ou State est une liste de lignes a afficher

write_state([]).
write_state([Line|Rest]) :-
   writeln(Line),
   write_state(Rest).
   

%**********************************************
% REGLES DE DEPLACEMENT (up, down, left, right)             
%**********************************************
   % format :   rule(+Rule_Name, ?Rule_Cost, +Current_State, ?Next_State)
   
rule(up,   1, S1, S2) :-
   vertical_permutation(_X,vide,S1,S2).

rule(down, 1, S1, S2) :-
   vertical_permutation(vide,_X,S1,S2).

rule(left, 1, S1, S2) :-
   horizontal_permutation(_X,vide,S1,S2).

rule(right,1, S1, S2) :-
   horizontal_permutation(vide,_X,S1,S2).

   %***********************
   % Deplacement horizontal            
   %***********************
    % format :   horizontal_permutation(?Piece1,?Piece2,+Current_State, ?Next_State)
    
horizontal_permutation(X,Y,S1,S2) :-
   append(Above,[Line1|Rest], S1),
   exchange(X,Y,Line1,Line2),
   append(Above,[Line2|Rest], S2).

   %***********************************************
   % Echange de 2 objets consecutifs dans une liste             
   %***********************************************
   
exchange(X,Y,[X,Y|List], [Y,X|List]).
exchange(X,Y,[Z|List1],  [Z|List2] ):-
   exchange(X,Y,List1,List2).

   %*********************
   % Deplacement vertical            
   %*********************
   
vertical_permutation(X,Y,S1,S2) :-
   append(Above, [Line1,Line2|Below], S1), % decompose S1
   delete(N,X,Line1,Rest1),    % enleve X en position N a Line1,   donne Rest1
   delete(N,Y,Line2,Rest2),    % enleve Y en position N a Line2,   donne Rest2
   delete(N,Y,Line3,Rest1),    % insere Y en position N dans Rest1 donne Line3
   delete(N,X,Line4,Rest2),    % insere X en position N dans Rest2 donne Line4
   append(Above, [Line3,Line4|Below], S2). % recompose S2

   %***********************************************************************
   % Retrait d'une occurrence X en position N dans une liste L (resultat R)
   %***********************************************************************
   % use case 1 :   delete(?N,?X,+L,?R)
   % use case 2 :   delete(?N,?X,?L,+R)   
   
delete(1,X,[X|L], L).
delete(N,X,[Y|L], [Y|R]) :-
   delete(N1,X,L,R),
   N is N1 + 1.
   
   %*******************************************************************
   % Coordonnees X(colonne),Y(Ligne) d'une piece P dans une situation U
   %*******************************************************************
    % format : coordonnees(?Coord, +Matrice, ?Element)
    % Définit la relation entre des coordonnees [Ligne, Colonne] et un element de la matrice
    /*
    Exemples
    
    ?- coordonnees(Coord, [[a,b,c],[d,e,f]],  e).        % quelles sont les coordonnees de e ?
    Coord = [2,2]
    yes
    
    ?- coordonnees([2,3], [[a,b,c],[d,e,f]],  P).        % qui a les coordonnees [2,3] ?
    P=f
    yes
    */

    
coordonnees([L,C], M, Elt) :-
	nth1(L,M,Ligne),
  	nth1(C,Ligne,Elt).  
                                           
   %*************
   % HEURISTIQUES
   %*************
   
heuristique(U,H) :-
    % heuristique1(U, H).  % au debut on utilise l'heuristique 1
    heuristique2(U, H).  % ensuite utilisez plutot l'heuristique 2  
   
   
   %****************
   %HEURISTIQUE no 1
   %****************
   % Nombre de pieces mal placees dans l'etat courant U
   % par rapport a l'etat final F

   
    heuristique1(U, H) :-
    final_state(F),
    diff(U,F,H).

    diff([],[],0).
    diff([L1|R1],[L2|R2],D) :-
        diff(R1,R2,S),
        diffL(L1,L2,S2),
        D is S + S2.

    diffL([],[],0).
    diffL([E1|R1],[E2|R2],D) :-
        diffE(E1,E2,S),
        diffL(R1,R2,S2),
        D is S + S2.

    diffE(vide,_,0).
    diffE(E,E,0) :- E \= vide.
    diffE(E1,E2,1) :-
        E1 \= E2,
        E1 \= vide.
          
    test_heuristique1(H,I):-
          initial_state(I),
          heuristique1(I,H).
          
   %****************
   %HEURISTIQUE no 2
   %****************
   
   % Somme des distances de Manhattan à parcourir par chaque piece
   % entre sa position courante et sa positon dans l'etat final

mtoL(F,List):- 
  flatten(F,List).
          
heuristique2(U, H) :-  
	final_state(F),
    mtoL(F,Liste),
    heur2(U,H,Liste,F).
          
heur2(_,0,[],_).
heur2(U,H,[P|R],F) :-
   disM(P,U,F,V),
   heur2(U,H2,R,F),
   H is V+H2.        
          
disM(vide,_,_,0).                           
disM(Elt,U,F,V) :-
	coordonnees([LU,CU],U,Elt),
   coordonnees([LF,CF],F,Elt),
   V is abs(LU-LF) + abs(CU-CF).
          
test_heuristique2(I,H):-
          initial_state(I),
          heuristique2(I,H).



