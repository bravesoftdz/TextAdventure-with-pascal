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
        id: integer;
        titulo, descricao: string;
        itens: array[0..10] of Objeto;
end;


//OBJETO JOGO
type Jogo = record
        cena_atual: integer;
        cenas: array[0..10] of Cena;
end;


//OBJETO IVENTARIO
type Inventario = record
        itens: array[0..10] of Objeto;
end;


function criaCena(ident : integer; tit, desc : string) : Cena;
var
        scene : Cena;
begin
        scene.id := ident;
        scene.titulo := tit;
        scene.descricao := desc;

        CriaCena := scene;
end;

function criaJogo () : Jogo;
var
        i, id : integer;
	cena : text;
	titulo, descricao : string;
	game : Jogo;

begin
	Assign(cena,'./Files/Cenas.txt');
        reset(cena);

    	i := 0;
	while not EOF(cena) do
    	begin
		readln(cena, id);
		readln(cena, titulo);
		readln(cena, descricao);

		game.cenas[i] := criaCena(id, titulo, descricao);

		i := i + 1;
    	end;
	close(cena);

	criaJogo := game;
end;

procedure printaCena (scene : Cena);
begin
        writeln(scene.titulo);
        writeln();
        writeln(scene.descricao);
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






