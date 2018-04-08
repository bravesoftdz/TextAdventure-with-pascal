{$mode objfpc}     // directive to be used for defining classes
{$m+}		   // directive to be used for using constructor

Program TextAdventure(output);
uses CRT;

//STRUCT OBJETO
type Objeto = record
        id, tipo, cena_alvo: integer;
        nome, descricao, result_posit, result_negat, comand_correct: string;
        resolvido, obtido: boolean;
end;


//STRUCT CENA
type Cena = record
        id, qtd_objetos: integer;
        titulo, descricao: string;
        itens: array[0..10] of Objeto;
end;


//STRUCT JOGO
type Jogo = record
        cena_atual: integer;
        cenas: array[0..10] of Cena;
end;


//STRUCT IVENTARIO
type Inventario = record
        itens: array[0..10] of Objeto;
end;

function criaObjeto(id_objeto, tipo : integer; nome, descricao_objeto, result_posit, result_negat, comand_correct : string; cena_alvo : integer) : Objeto;
var
    obj : Objeto;
begin
    obj.id := id_objeto;
    obj.tipo := tipo;
    obj.nome := nome;
    obj.descricao := descricao_objeto;
    obj.result_posit := result_posit;
    obj.result_negat := result_negat;
    obj.comand_correct := comand_correct;
    obj.cena_alvo := cena_alvo;
    obj.obtido := false;
    obj.resolvido := false;

    criaObjeto := obj;
end;

function criaCena(ident : integer; tit, desc : string; qtd_objetos : integer) : Cena;
var
        scene : Cena;
begin
        scene.id := ident;
        scene.titulo := tit;
        scene.descricao := desc;
        scene.qtd_objetos := qtd_objetos;
        criaCena := scene;
end;

function criaJogo () : Jogo;
var
        i, j, id_cena, qtd_objetos : integer;
	    cena : text;
	    titulo, descricao_cena : string;
	    game : Jogo;

        id_objeto, tipo, cena_alvo: integer;
        nome, descricao_objeto, result_posit, result_negat, comand_correct: string;


begin
	Assign(cena,'./Files/Cenas.txt');
        reset(cena);

    	i := 0;
	while not EOF(cena) do
    	begin
                //le Atributos da Cena
		readln(cena, id_cena);
		readln(cena, titulo);
		readln(cena, descricao_cena);
        readln(cena, qtd_objetos);

        game.cenas[i] := criaCena(id_cena, titulo, descricao_cena, qtd_objetos);


                for j:=0 to qtd_objetos-1 do
                begin
                        //le Atributos dos Objetos da Cena
                        readln(cena, id_objeto);
                        readln(cena, tipo);
                        readln(cena, nome);
                        readln(cena, descricao_objeto);
                        readln(cena, result_posit);
                        readln(cena, result_negat);
                        readln(cena, comand_correct);
                        cena_alvo := i;
                        game.cenas[i].itens[j] := criaObjeto(id_objeto, tipo, nome, descricao_objeto, result_posit, result_negat, comand_correct, cena_alvo);
                end;
		i := i + 1;
    	end;
	close(cena);

	criaJogo := game;
end;

procedure printaCena (scene : Cena);
var
    i : integer;
begin
        writeln('##XxCENAxX##');
        writeln(scene.titulo);
        writeln(scene.descricao);
        writeln('##XxCENA-OBJETOSxX##');
        for i:=0 to scene.qtd_objetos-1 do
        begin
            writeln(scene.itens[i].nome);
            write('Comando Correto: ');
            writeln(scene.itens[i].comand_correct);
        end;
end;




var
        title : text;
        linha: string;
        game : Jogo;
begin
    clrscr(); 					//Limpa o console

	Assign(title,'./Files/Title.txt');
        reset(title);
        while not EOF(title) do
        begin
            readln(title, linha);
            writeln(linha);
            Delay(200);
        end;
        close(title);

        clrscr();                               //Limpa o console
        Delay(1000);

        game := criaJogo();
        printaCena(game.cenas[0]);
        readln(linha);				//so para congelar o texto

        Delay(1000);

end.






