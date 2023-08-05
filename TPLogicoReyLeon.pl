
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

pesoHormiga(2). 

%peso(Personaje, Peso) 
peso(pumba, 100). 
peso(timon, 50). 
peso(simba, 200). 


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
    personajes(Personaje),
    findall(Nombre,comio(Personaje,hormiga(Nombre)),ComioHormiga),
    length(ComioHormiga,Cantidad),
    Cantidad >= 2.
personajes(Personaje):- peso(Personaje,_).

% 1)c) Si un personaje es cucarachofóbico (no comió cucarachas). 
%?-cucarachofobico(X). 
%X = simba

cucarachofobico(Personaje) :-
    personajes(Personaje),
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

