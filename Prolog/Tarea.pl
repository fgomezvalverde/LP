%% TAREA CORTA
% Fabian Gomez Valverde
%  201281511

primer_elem([X|_Y],X):-!.

ultimo_elem(LISTA,R):-reverse(LISTA,REVER), primer_elem(REVER,R).

eslista([]):-!.
eslista([_X|Y]):-eslista(Y).

nthtail(POSICION,LISTA,R) :- nthtail_aux(POSICION,LISTA,0,R).

nthtail_aux(_,[],_,[]).
nthtail_aux(LIMITE,[_|LISTA],CONTADOR,R) :- LIMITE > CONTADOR,
	CONT is CONTADOR+1, nthtail_aux(LIMITE,LISTA,CONT,R).
nthtail_aux(LIMITE,[X|T],CONTADOR,R) :- CONT is CONTADOR+1,
	nthtail_aux(LIMITE,T,CONT,R1),
	lists:append([X],R1,R).

%%===================================== EJERCICIO 5
reverse([],_).
reverse([X|M],Z):-reverse(M,S), lists:append(S,[X],Z).
%%===================================== EJERCICIO 6 MALO FALSE
palindrome(LISTA):- reverse(LISTA,LISTA),!.

%%===================================== EJERCICIO 7
flatten([],[]).
flatten([ELEM|LISTA],R):- flatten(ELEM,R2),flatten(LISTA,R3), lists:append(R2,R3,R).
flatten(X,[X]).

%%===================================== EJERCICIO 8
compress([ELE|LISTA],R):- compress_aux(ELE,LISTA,R).

compress_aux(ELE,[],[ELE]).
compress_aux(ELE,[ELE|LISTA],R) :-compress_aux(ELE,LISTA,R).
compress_aux(ELE,[PRI|LISTA],R) :- compress_aux(PRI,LISTA,R2), lists:append([ELE],R2,R).

%%===================================== EJERCICIO 9
consecDups([ELE|LISTA],R) :- consecDups_aux([ELE],LISTA,R).

consecDups_aux(ELE,[],[ELE]).
consecDups_aux([ELE|LISTA1],[ELE|LISTA2],R) :-
	lists:append([ELE],LISTA1,R2),lists:append(R2,[ELE],R3),consecDups_aux(R3,LISTA2,R).
consecDups_aux(LISTA1,[ELE1|LISTA2],R) :- consecDups_aux([ELE1],LISTA2,R2),
	lists:append([LISTA1],R2,R).
%%===================================== EJERCICIO 10
encode([ELE|LISTA],R) :- encode_aux([ELE],LISTA,R).

encode_aux(T1,[],R) :- lists:length(T1,LEN),primer_elem(T1,CAR),lists:append([LEN],[CAR],R).
encode_aux([X|T1],[X|T2],R) :- lists:append([X],T1,R1),lists:append(R1,[X],R2),
	encode_aux(R2,T2,R).
encode_aux(T1,[X|T2],R) :- lists:length(T1,LEN),primer_elem(T1,CAR),
	lists:append([LEN],[CAR],R1),encode_aux([X],T2,R2),lists:append([R1],R2,R).
%%===================================== EJERCICIO 11
encode_modicated([ELE|LISTA],R) :- encode_aux([ELE],LISTA,R).

encode_modicated_aux(T1,[],R) :- lists:length(T1,LEN),primer_elem(T1,CAR),lists:append([LEN],[CAR],R).
encode_modicated_aux([X|T1],[X|T2],R) :- lists:append([X],T1,R1),lists:append(R1,[X],R2),
	encode_modicated_aux(R2,T2,R).
encode_modicated_aux([Y|[]],[X|T2],R) :- encode_modificate_aux([X],T2,R1),
	lists:append([Y],R1,R).
encode_modicated_aux(T1,[X|T2],R) :- lists:length(T1,LEN),primer_elem(T1,CAR),
	lists:append([LEN],[CAR],R1),encode_modicated_aux([X],T2,R2),lists:append([R1],R2,R).

%%===================================== EJERCICIO 12
decode([],[]).
decode([ELEM|LISTA],R) :- decode_aux(ELEM,R1),decode(LISTA,R2),
	lists:append(R1,R2,R).

decode_aux([LIMITE|LISTA],R) :- replic(LISTA,LIMITE,R).
decode_aux(T,[T]).
%%===================================== EJERCICIO 13
% ES EL MISMO QUE EL 9
%%===================================== EJERCICIO 14
duplicate([],[]).
duplicate([X|T],R) :- lists:append([X],[X],R1),duplicate(T,R2),lists:append(R1,R2,R).
%%===================================== EJERCICIO 15
replic([],_,[]).
replic([X|T],CONTADOR,R) :-
	replic_aux(X,CONTADOR,R1),replic(T,CONTADOR,R2),
	lists:append(R1,R2,R).

replic_aux(_,0,[]).
replic_aux(VALOR,CONTADOR,R) :- CONT is CONTADOR-1, replic_aux(VALOR,CONT,R1),
	lists:append([VALOR],R1,R).
%%===================================== EJERCICIO 16
drop(LISTA,LIMITE,R) :- drop_aux(LISTA,LIMITE,1,R).

drop_aux([],_,_,[]).
drop_aux([_|T],LIMITE,LIMITE,R) :- drop_aux(T,LIMITE,1,R).
drop_aux([X|T],LIMITE,CONTADOR,R) :-CONT is CONTADOR+1, drop_aux(T,LIMITE,CONT,R1),
	lists:append([X],R1,R).

%%===================================== EJERCICIO 17
splitAt(LISTA,LIMITE,R) :- splitAt_aux(LISTA,LIMITE,1,R1),nthtail(LIMITE,LISTA,R2),
	lists:append([R1],[R2],R).

splitAt_aux([],_,_,[]).
splitAt_aux([X|_],LIMITE,LIMITE,[X]).
splitAt_aux([X|T],LIMITE,CONTADOR,R):- CONT is CONTADOR+1,
	splitAt_aux(T,LIMITE,CONT,R1), lists:append([X],R1,R).
%%===================================== EJERCICIO 18
slice(LISTA,BEG,END,R) :- nthtail(BEG,LISTA,R1),
	VALOR is END-BEG,
	splitAt_aux(R1,VALOR,1,R2),lists:append(R1,R2,R).
%%===================================== EJERCICIO 19
rotate(LISTA,CONTADOR,R):- CONTADOR >= 0,nthtail(CONTADOR,LISTA,R1),
	splitAt_aux(LISTA,CONTADOR,1,R2),
	lists:append(R1,R2,R).
rotate(LISTA,CONTADOR) :- lists:length(LISTA,LEN),
	CONT is LEN+CONTADOR,
	nthtail(CONT,LISTA,R1),
	splitAt_aux(LISTA,LEN,1,R2),
	lists:append(R1,R2,R).

%%===================================== EJERCICIO 20
remove_at([],_,[]).
remove_at([_|LISTA],0,R) :- remove_at(LISTA,-1,R).
remove_at([ELE|LISTA],POS,R) :- POS1 is POS-1,
	remove_at(LISTA,POS1,R1),
	lists:append([ELE],R1,R).
%%===================================== EJERCICIO 21
insert_at(_,[],_,[]).
insert_at(CHAR,LISTA,0,R) :-
	insert_at(CHAR,LISTA,-1,R1),
	lists:append([CHAR],R1,R).
insert_at(CHAR,[ELE|LISTA],POS,R) :- POS1 is POS-1,
	insert_at(CHAR,LISTA,POS1,R1),
	lists:append([ELE],R1,R).

%%===================================== EJERCICIO 22

range(BEG,END,R) :- BEG >=END, R is [BEG].
range(BEG,END,R) :- BEG1 is BEG+1,
	range(BEG1,END,R1),
	lists:append([BEG],R1,R).
%%===================================== EJERCICIO 23
rnd_select(_,1,[]).
rnd_select(LISTA,CONT,R) :- lists:length(LISTA,LEN),
	random(1,LEN,RAN),
	lists:nth0(RAN,LISTA,R1),
	CONT1 is CONT-1,
	rnd_select(LISTA,CONT1,R2),
	lists:append([R1],R2,R).
%%===================================== EJERCICIO 24
lotto_select(1,_,[]).
lotto_select(CONTADOR,LIMITE,R) :- random(1,LIMITE,RAN),
	CONT1 is CONTADOR-1,
	lotto_select(CONT1,LIMITE,R1),
	lists:append([RAN],R1,R).
%%===================================== EJERCICIO 25
permute([], []).
permute([X|Rest], L) :-
    permute(Rest, L1),
    select(X, L, L1).
