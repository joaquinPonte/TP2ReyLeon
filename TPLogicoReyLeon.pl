
%vaquitaSanAntonio(nombre,peso).
%cucarachas(nombre,tamanio,peso).
%hormigas(nombre).

%comio(Personaje, Bicho)
comio(pumba, vaquitaSanAntonio(gervasia,3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger,15,6)).
comio(pumba, cucaracha(erikElRojo,25,70)).

comio(timon, vaquitaSanAntonio(romualda,4)).
comio(timon, cucaracha(gimeno,12,8)).
comio(timon, cucaracha(cucurucha,12,5)).

comio(simba, vaquitaSanAntonio(remeditos,4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).

% Punto2)
comio(shenzi,hormiga(conCaraDeSimba)).

pesoHormiga(2).

%peso(Personaje, Peso) 
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).

% Punto2)
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

persigue(scar, timon). 
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).

% Punto4)
persigue(scar, mufasa).


% 1)a) Qué cucaracha es jugosita: ó sea, hay otra con su mismo tamaño 

%      pero ella es más gordita. 
%?-jugosita(cucaracha(gimeno,12,8)). 
%Yes 

jugosita(cucaracha(_,Tamanio,Peso1)) :-
    findall(Peso,comio(_, cucaracha(_,Tamanio,Peso)),ListaPesos),
    length(ListaPesos,Cantidad),
    Cantidad > 1,
    max_member(Peso1, ListaPesos).

% 1)b) Si un personaje es hormigofílico... (Comió al menos dos hormigas).

%?-hormigofilico(X). 
%X = pumba; 
%X = simba. 

hormigofilico(Personaje) :-
    personajes(Personaje),                                          %Inversivilidad
    findall(Nombre,comio(Personaje,hormiga(Nombre)),ComioHormiga),
    length(ComioHormiga,Cantidad),
    Cantidad >= 2.
personajes(Personaje):- comio(Personaje,vaquitaSanAntonio(_,_)).

% 1)c) Si un personaje es cucarachofóbico (no comió cucarachas). 

%?-cucarachofobico(X). 
%X = simba

cucarachofobico(Personaje) :-
    personajes(Personaje),                                          %Inversibilidad
    findall(Bicho,comio(Personaje,Bicho),BichosComidos),
    not(member(cucaracha(_,_,_),BichosComidos)).


% 1)d) Conocer al conjunto de los picarones. 
%      Un personaje es picarón si comió una cucaracha jugosita ó si se 
%      come a Remeditos la vaquita. Además, pumba es picarón de por sí. 

%?-picarones(L). 
%L = [pumba, timon, simba] 

picarones(Picarones) :-
    bagof(Personaje,picaron(Personaje),Picarones).

picaron(pumba).
picaron(Personaje) :-
    comioJugosita(Personaje).
picaron(Personaje) :-
    comioRemeditos(Personaje).
comioJugosita(Personaje) :-
    comio(Personaje, cucaracha(_,Tamanio,Peso)), 
    jugosita(cucaracha(_,Tamanio,Peso)).
comioRemeditos(Personaje) :-
    comio(Personaje, vaquitaSanAntonio(remeditos,_)).

% 2)

% 2)a) Se quiere saber cuánto engorda un personaje (sabiendo que engorda
%      una cantidad igual a la suma de los pesos de todos los bichos en 
%      su menú). Los bichos no engordan. 

%?-cuantoEngorda(Personaje, Peso). 
%Personaje= pumba 
%Peso = 83; 
%Personaje= timon 
%Peso = 17; 
%Personaje= simba 
%Peso = 10

cuantoEngorda(Personaje,Peso) :-
    personajesLivianos(Personaje),                          %Inversivilidad
    findall(Bichos,comio(Personaje,Bichos),ListaBichos),
    sumaPesos(ListaBichos,Peso).
personajesLivianos(Personaje) :- peso(Personaje,50).
personajesLivianos(Personaje) :- peso(Personaje,100).
personajesLivianos(Personaje) :- peso(Personaje,200).

sumaPesos([],0).                                            %Recursividad
sumaPesos([Bicho|Resto], Suma) :-                           %Recursividad
    pesoBicho(Bicho,Peso),
    sumaPesos(Resto,SumaParcial),
    Suma is Peso + SumaParcial.

pesoBicho(vaquitaSanAntonio(_, Peso), Peso).                %Polimorfismo
pesoBicho(hormiga(_),Peso) :-                               %Polimorfismo
    pesoHormiga(Peso).
pesoBicho(cucaracha(_,_,Peso),Peso).                        %Polimorfismo

% 2)b) Pero como indica la ley de la selva, cuando un personaje persigue 
%      a otro, se lo termina comiendo, y por lo tanto también engorda. 
%      Realizar una nueva versión del predicado cuantoEngorda. 

%?-cuantoEngorda(scar,Peso). 
%Peso = 150 
%(es la suma de lo que pesan pumba y timon) 

%?-cuantoEngorda(shenzi,Peso). 
%Peso = 502 
%(es la suma del peso de scar y simba, más 2 que pesa la hormiga) 

cuantoEngorda2(Personaje,PesoComida) :-
    personajes2(Personaje),                                 %Inversivilidad
    bagof(Comida,comida2(Personaje,Comida),ListaComida), 
    sumaPesos2(ListaComida,PesoComida).
personajes2(Personaje):- peso(Personaje,_).
comida2(Personaje,Presa) :-
    persigue(Personaje,Presa).
comida2(Personaje,Presa) :-
    comio(Personaje,Presa).

sumaPesos2([],0).                                           %Recursividad
sumaPesos2([Comida|Resto], Suma) :-                         %Recursividad
    pesoComida2(Comida,Peso),
    sumaPesos2(Resto,SumaParcial),
    Suma is Peso + SumaParcial.

pesoComida2(Personaje,Peso) :-                              %Polimorfismo
    peso(Personaje,Peso).
pesoComida2(vaquitaSanAntonio(_, Peso), Peso).              %Polimorfismo
pesoComida2(hormiga(_),Peso) :-                             %Polimorfismo
    pesoHormiga(Peso).
pesoComida2(cucaracha(_,_,Peso),Peso).                      %Polimorfismo

% 2)c) Ahora se complica el asunto, porque en realidad cada animal antes
%      de comerse a sus víctimas espera a que éstas se alimenten. De esta
%      manera, lo que engorda un animal no es sólo el peso original de sus
%      víctimas, sino también hay que tener en cuenta lo que éstas comieron
%      y por lo tanto engordaron. Hacer una última versión del predicado. 

%?-cuantoEngorda(scar,Peso). 
%Peso = 250 

%(150, que era la suma de lo que pesan pumba y timon, más 83 que se come 
%pumba y 17 que come timon ) 

%?-cuantoEngorda(shenzi,Peso). 
%Peso = 762 

%(502 era la suma del peso de scar y simba, más 2 de la hormiga. A eso se 
%le suman los 250 de todo lo que engorda scar y 10 que engorda simba) 

cuantoEngorda3(Personaje,PesoComida) :-
    personajes3(Personaje),                                 %Inversivilidad
    bagof(Comida,comida3(Personaje,Comida),ListaComida), 
    sumaPesos3(ListaComida,PesoComida).
personajes3(Personaje):- peso(Personaje,_).
comida3(Personaje,Presa) :-
    persigue(Personaje,Presa).
comida3(Personaje,Presa) :-
    comio(Personaje,Presa).

sumaPesos3([],0).                                           %Recursividad
sumaPesos3([Comida|Resto], Suma) :-                         %Recursividad
    pesoComida3(Comida,Peso),
    sumaPesos3(Resto,SumaParcial),
    Suma is Peso + SumaParcial.

pesoComida3(Personaje,Peso) :-                              %Polimorfismo
    peso(Personaje,PesoPresa),
    cuantoEngorda3(Personaje,PesoComidaDeComida),
    Peso is PesoPresa + PesoComidaDeComida.
pesoComida3(vaquitaSanAntonio(_, Peso), Peso).              %Polimorfismo
pesoComida3(hormiga(_),Peso) :-                             %Polimorfismo
    pesoHormiga(Peso).
pesoComida3(cucaracha(_,_,Peso),Peso).                      %Polimorfismo

% 3) Para acelerar el plato de comida… Se quiere saber todas las posibles 
%    combinaciones posibles de comidas que puede tener un personaje dado.
%    Se sabe que la comida no es solo lo que comió si no también los 
%    animales que persigue.

%combinaComidas(Personaje, ListaComidas)

combinacionComidas(Personaje,CombinacionesPosibles) :-
    personajes3(Personaje),                                             %Inversivilidad
    findall(Comida,comida3(_,Comida),ListaComida),
    list_to_set(ListaComida,ComidaDisponible),
    comidasPosibles(Personaje,ComidaDisponible, CombinacionesPosibles).

comidasPosibles(_,[],[]).                                               %Recursividad
comidasPosibles(Personaje,[Comida|Resto],[Comida|Posibles]) :-          %Recursividad
    comioComida(Personaje,Comida),
    comidasPosibles(Personaje,Resto,Posibles).
comidasPosibles(Personaje,[_|Resto],Posibles) :-                        %Recursividad
    comidasPosibles(Personaje,Resto,Posibles).

comioComida(Personaje,vaquitaSanAntonio(Nombre,Peso)) :-                %Polimorfismo
    comio(Personaje,vaquitaSanAntonio(Nombre,Peso)).
comioComida(Personaje,cucaracha(Nombre,Tamanio,Peso)) :-                %Polimorfismo
    comio(Personaje,cucaracha(Nombre,Tamanio,Peso)).    
comioComida(Personaje,hormiga(Nombre)) :-                               %Polimorfismo
    comio(Personaje,hormiga(Nombre)).
comioComida(Personaje,Comida) :-                                        %Polimorfismo
    persigue(Personaje,Comida).

% 4) Buscando el rey… Sabiendo que todo animal adora a todo lo que no se 
%    lo come o no lo persigue, encontrar al rey. El rey es el animal a 
%    quien sólo hay un animal que lo persigue y todos adoran.  

%?-rey(R). 
%R = mufasa. 
%(sólo lo persigue scar y todos los adoran) 

rey(R) :-
    persigue(_, R),                                                     %Inversivilidad
    unicoPerseguidor(R),
    esAdoradoPorTodos(R).

esAdoradoPorTodos(Animal) :-
   findall(OtroAnimal, noAdora(OtroAnimal, Animal), NoAdoradores),
   length(NoAdoradores, 0).

noAdora(Animal1, Animal2) :-
    persigue(Animal2, Animal1).
noAdora(Animal1, Animal2) :-
    comio(Animal2, Animal1).

unicoPerseguidor(Animal) :-
    findall(Persiguiendo, persigue(Persiguiendo, Animal), Perseguidores),
    length(Perseguidores, 1).