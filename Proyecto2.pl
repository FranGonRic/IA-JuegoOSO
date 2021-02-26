% --- Francisco Emilio González Rico ---
% --- 175575 ---
% --- Luciano Montes de Oca Villa ---
% --- 173670 ---
% --- Proyecto II: Utilización de algoritmos de búsqueda inteligente para juegos sencillos ---
% --- Inteligencia Artificial ---
% --- Juego elegido: OSO ---
% --- El tablero original es de 5x5 --- 


% --- Algoritmo Minimax ---
% --- Codigo modificado de MINIMAX sacado de http://www.montefiore.ulg.ac.be/~lens/prolog/tutorials/minimax.pl ---
minimax(Pos, BestNextPos, Val,N) :-
    % Legal moves in Pos produce NextPosList
    N>=0,
    bagof(NextPos, move(Pos, NextPos), NextPosList),
    best(NextPosList, BestNextPos, Val,N), !
    ;
    evalPos(Pos, Val).     % Pos has no successors -> evaluate the positition

best([Pos], Pos, Val,N) :-
    N1 is N-1, minimax(Pos, _, Val,N1), !.

best([Pos1 | PosList], BestPos, BestVal,N) :-
    N1 is N-1, minimax(Pos1, _, Val1,N1),
    best(PosList, Pos2, Val2,N),
    betterOf(Pos1, Val1, Pos2, Val2, BestPos, BestVal).

betterOf(Pos0, Val0, _, Val1, Pos0, Val0) :-   % Pos0 better than Pos1
    min_to_move(Pos0),                         % MIN to move in Pos0
    Val0 > Val1, !                             % MAX prefers the greater value
    ;
    max_to_move(Pos0),                         % MAX to move in Pos0
    Val0 < Val1, !.                            % MIN prefers the lesser value

betterOf(_, _, Pos1, Val1, Pos1, Val1).        % Otherwise Pos1 better than Pos0


% --- Definición del juego OSO ---
find(Tabla,X,Y,N) :- nth0(Y, Tabla, Sublista),nth0(X, Sublista, N).

writeTable(Tab) :- writeTableRec(Tab).
writeTableRec([X|L]) :- write(X),write('\n'),writeTableRec(L).
writeTableRec([]) :- write('\n').

createTable(N, Val, Tab) :- createList(N,Val,Lis),createList(N,Lis,Tab).
createList(1,Val,[Val]) :- !.
createList(N,Val,[Val|Tail]) :- N1 is N-1, createList(N1,Val,Tail),!.

listSum([], 0).
listSum([Head | Tail], TotalSum) :-listSum(Tail, Sum1), TotalSum is Head + Sum1.

% --- Establece los puntos cardinales de acuerdo a la posición de la letra ---
north(Tablero,X,Y,Letra) :- Y1 is Y-1,find(Tablero,X,Y1,Letra).
south(Tablero,X,Y,Letra) :- Y1 is Y+1,find(Tablero,X,Y1,Letra).
east(Tablero,X,Y,Letra) :- X1 is X+1,find(Tablero,X1,Y,Letra).
west(Tablero,X,Y,Letra) :- X1 is X-1,find(Tablero,X1,Y,Letra).
northeast(Tablero,X,Y,Letra) :- Y1 is Y-1,X1 is X+1,find(Tablero,X1,Y1,Letra).
northwest(Tablero,X,Y,Letra) :- Y1 is Y-1,X1 is X-1,find(Tablero,X1,Y1,Letra).
southeast(Tablero,X,Y,Letra) :- Y1 is Y+1,X1 is X+1,find(Tablero,X1,Y1,Letra).
southwest(Tablero,X,Y,Letra) :- Y1 is Y+1,X1 is X-1,find(Tablero,X1,Y1,Letra).

% --- Establece las nuevas direcciones en los puntos cardinales ---
dir(X,Y,X,Y1,n) :- Y1 is Y-1.
dir(X,Y,X,Y1,s) :- Y1 is Y+1.
dir(X,Y,X1,Y,w) :- X1 is X-1.
dir(X,Y,X1,Y,e) :- X1 is X+1.
dir(X,Y,X1,Y1,ne) :- X1 is X+1, Y1 is Y-1.
dir(X,Y,X1,Y1,nw) :- X1 is X-1, Y1 is Y-1.
dir(X,Y,X1,Y1,se) :- X1 is X+1, Y1 is Y+1.
dir(X,Y,X1,Y1,sw) :- X1 is X-1, Y1 is Y+1.

% --- Checa si la letra es una s ---
checarPunto(Tablero,X,Y,s) :- north(Tablero,X,Y,o), south(Tablero,X,Y,o).
checarPunto(Tablero,X,Y,s) :- east(Tablero,X,Y,o), west(Tablero,X,Y,o).
checarPunto(Tablero,X,Y,s) :- northeast(Tablero,X,Y,o), southwest(Tablero,X,Y,o).
checarPunto(Tablero,X,Y,s) :- northwest(Tablero,X,Y,o), southeast(Tablero,X,Y,o).

% --- Checa si la letra es una o ---
checarPunto(Tablero,X,Y,o) :- north(Tablero,X,Y,s), dir(X,Y,X1,Y1,n), north(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- south(Tablero,X,Y,s), dir(X,Y,X1,Y1,s), south(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- east(Tablero,X,Y,s), dir(X,Y,X1,Y1,e), east(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- west(Tablero,X,Y,s), dir(X,Y,X1,Y1,w), west(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- northwest(Tablero,X,Y,s), dir(X,Y,X1,Y1,nw), northwest(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- northeast(Tablero,X,Y,s), dir(X,Y,X1,Y1,ne), northeast(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- southwest(Tablero,X,Y,s), dir(X,Y,X1,Y1,sw), southwest(Tablero,X1,Y1,o).
checarPunto(Tablero,X,Y,o) :- southeast(Tablero,X,Y,s), dir(X,Y,X1,Y1,se), southeast(Tablero,X1,Y1,o).

% --- Tabla para probar numeroPuntos: ---
% [[o,o,s,x,x],[s,x,x,x,x],[x,o,o,x,x],[x,x,x,x,x],[x,x,x,x,x]]

% --- Sirve para poner el puntaje del juego ---
numeroPuntos(Tablero,X,Y,o,Puntos) :- aggregate_all(count, checarPunto(Tablero,X,Y,o), Puntos).
numeroPuntos(Tablero,X,Y,s,Puntos) :- aggregate_all(count, checarPunto(Tablero,X,Y,s), Puntos).

% --- Coloca la letra que decida el jugador ---
ponerLetra(Tabla,X,Y,s,TablaRes) :- 
nth0(Y, Tabla, Sublista,R1),nth0(X, Sublista, x,R2),
nth0(X, SublistaRes, s,R2),nth0(Y, TablaRes, SublistaRes,R1).

ponerLetra(Tabla,X,Y,o,TablaRes) :- 
nth0(Y, Tabla, Sublista,R1),nth0(X, Sublista, x,R2),
nth0(X, SublistaRes, o,R2),nth0(Y, TablaRes, SublistaRes,R1).

% --- Funcion que usa el algoritmo minimax para jugar OSO ---
% Posicion = [Tabla,Xprevia,Yprevia,Lprevia,Round,Orden(quien va primero),Valor de posicion]
move([Tabla,_,_,_,N1,O,HVal], [TablaRes,X,Y,L,N2,O,HValRes]) :- ponerLetra(Tabla,X,Y,L,TablaRes), N2 is N1+1, 
min_to_move([TablaRes,X,Y,L,N2,O,_]), numeroPuntos(TablaRes,X,Y,L,Val), HValRes is HVal+Val.
move([Tabla,_,_,_,N1,O,HVal], [TablaRes,X,Y,L,N2,O,HValRes]) :- ponerLetra(Tabla,X,Y,L,TablaRes), N2 is N1+1, 
max_to_move([TablaRes,X,Y,L,N2,O,_]), numeroPuntos(TablaRes,X,Y,L,Val), HValRes is HVal-Val.
evalPos([_,_,_,_,_,_,HVal], HVal).
evalPoints([Tablero,X,Y,L,_,_,_], Val) :- numeroPuntos(Tablero,X,Y,L,Val).
min_to_move([_,_,_,_,N,f,_]) :- N mod 2 =:= 1.
min_to_move([_,_,_,_,N,l,_]) :- N mod 2 =:= 0.
max_to_move([_,_,_,_,N,f,_]) :- N mod 2 =:= 0.
max_to_move([_,_,_,_,N,l,_]) :- N mod 2 =:= 1.

% --- Sirve para pedir al jugador la posición y letra de su siguiente jugada ---
movimientoJugador([Tab,_,_,_,N,O,_],PosRes) :- N1 is N+1, writeTable(Tab),write('\nEscoge la posicion y letra que desea poner con el siguiente formato: [X,Y,L]'),
read([X,Y,L]),ponerLetra(Tab,X,Y,L,TabRes),PosRes = [TabRes,X,Y,L,N1,O,[0]],writeTable(TabRes).

% --- Función para iniciar el juego OSO con tablero original (de 5x5) ---
gameOSO(N):- Pos =[[[x,x,x,x,x],[x,x,x,x,x],[x,x,x,x,x],[x,x,x,x,x],[x,x,x,x,x]],_,_,_,0,_,0],
write('Quien empieza el juego:\n 1) El usuario\n 2) La computadora\n'),read(X),switch(X,Pos,0,0,N).

gameOSO():- Pos =[[[x,x,x,x,x],[x,x,x,x,x],[x,x,x,x,x],[x,x,x,x,x],[x,x,x,x,x]],_,_,_,0,_,0],
write('Quien empieza el juego:\n 1) El usuario\n 2) La computadora\n'),read(X),switch(X,Pos,0,0,3).

% -----------------------------------------------------------------------------------------------
% --- Función para iniciar el juego OSO con un tablero de 3x3 ---
gameOSOred(D):- Pos =[[[x,x,x],[x,x,x],[x,x,x]],_,_,_,0,_,0],
write('Quien empieza el juego:\n 1) El usuario\n 2) La computadora\n'),read(X),switch(X,Pos,0,0,D).

gameOSOred():- Pos =[[[x,x,x],[x,x,x],[x,x,x]],_,_,_,0,_,0],
write('Quien empieza el juego:\n 1) El usuario\n 2) La computadora\n'),read(X),switch(X,Pos,0,0,3).
% -----------------------------------------------------------------------------------------------
% -----------------------------------------------------------------------------------------------
% --- Función para iniciar el juego OSO con un tablero variable cuadrado ---
gameOSOvar(D,N):- Pos =[Tab,_,_,_,0,_,0], createTable(N,x,Tab),
write('Quien empieza el juego:\n 1) El usuario\n 2) La computadora\n'),read(X),switch(X,Pos,0,0,D).
% -----------------------------------------------------------------------------------------------

% --- Función para realizar la jugada con el movimiento elegido por el jugador ---
% --- Determina el puntaje después de esa jugada ---
% --- Evalúa si el juego continúa o ahí termina ---
% --- Escribe la jugada que eligió la computadora ---
switch(1,[Tab,_,_,_,N,l,_],P1,P2,D) :- movimientoJugador([Tab,_,_,_,N,l,_],PosRes),
evalPoints(PosRes, SumP2),P2n is P2+SumP2,
write('\nPuntaje:\tCompu\tJugador\n\t\t'),write(P1),write('\t'),write(P2n),write('\n'),
juegoSigue(PosRes,P1,P2n),
minimax(PosRes,[Tab1,X,Y,L,N1,l,_],Val,D),write(Val),
evalPoints([Tab1,X,Y,L,N1,l,_], SumP1),P1n is P1+SumP1,
write('Movimiento de la compu '),write([X,Y,L]),write('\n'),
write('\nPuntaje:\tCompu\tJugador\n\t\t'),write(P1n),write('\t'),write(P2n),write('\n'),
switch(1,[Tab1,X,Y,L,N1,l,_],P1n,P2n,D),!.

switch(2,Pos,P1,P2,D) :- minimax(Pos,[Tab,X,Y,L,N,f,_],Val,D),write(Val),
evalPoints([Tab,X,Y,L,N,f,_], SumP1),P1n is P1+SumP1,
write('Movimiento de la compu '),write([X,Y,L]),
write('\nPuntaje:\tCompu\tJugador\n\t\t'),write(P1n),write('\t'),write(P2),write('\n'),
juegoSigue(PosRes,P1n,P2),
movimientoJugador([Tab,X,Y,L,N,f,_],PosRes), 
evalPoints(PosRes, SumP2),P2n is P2+SumP2,
write('\nPuntaje:\tCompu\tJugador\n\t\t'),write(P1n),write('\t'),write(P2n),write('\n'),
switch(2,PosRes,P1n,P2n,D),!.

% --- Determina si el juego puede continuar o si ha finalizado ---
% --- Define el ganador del juego o si hubo empate ---
juegoSigue(Pos,_,_) :- [Tab|_]=Pos,find(Tab,_,_,x).
juegoSigue(_,P1,P2) :- write('Termino el juego\n'),ganador(P1,P2).
ganador(P1,P2) :- P1>P2,write('Gano la Computadora\n'),abort.
ganador(P1,P2) :- P2>P1,write('Gano el Jugador\n'),abort.
ganador(P1,P2) :- P2=:=P1,write('Juego empatado. Nadie gano\n'),abort.