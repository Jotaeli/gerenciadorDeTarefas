import Foundation


    //Criaçao de estrututra Tarefa com prorpiedade titulo, descriçao e concluida
struct Tarefa: Codable {
    var titulo: String
    var descricao: String
    var concluida: Bool
}


var listaDeTarefas = [Tarefa]()


    // Criação do caminho para o arquivo onde os dados serão armazenados
let caminhoParaArquivo = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("data.json")


do {
    let dadosDoArquivo = try Data(contentsOf: caminhoParaArquivo)
    let decoder = JSONDecoder()
    let listaDecodificada = try decoder.decode([Tarefa].self, from: dadosDoArquivo)
    listaDeTarefas = listaDecodificada
} catch {
    print("Erro ao carregar tarefas: \(error.localizedDescription)")
}


func listarTarefas() {
    // Verifica se a lista de tarefas está vazia
    if listaDeTarefas.isEmpty {
        // Se estiver vazia, exibe mensagem informando que não há tarefas
        print("Não há tarefas para mostrar.")
    } else {
        // Se a lista não estiver vazia, percorre cada tarefa da lista
        for (indice, tarefa) in listaDeTarefas.enumerated() {
            let status = tarefa.concluida ? "concluída" : "pendente"
            // Exibe as informações da tarefa, incluindo índice, título, descrição e status
            print("\(indice + 1). \(tarefa.titulo) - \(tarefa.descricao) (\(status))")
        }
    }
}


func adicionarTarefa() {  // Solicita que o usuário digite o título da tarefa a ser adicionada
    print("Digite o título da tarefa que deseja adicionar:")
    guard let titulo = readLine(), !titulo.isEmpty else {  // Lê a entrada do usuário e verifica se não está vazia
        print("Título inválido.")
        return
    }
    
    print("Digite a descrição da tarefa que deseja adicionar:")
    guard let descricao = readLine(), !descricao.isEmpty else {
        print("Descrição inválida.")
        return
    }
    
    let novaTarefa = Tarefa(titulo: titulo, descricao: descricao, concluida: false)
    listaDeTarefas.append(novaTarefa)
    
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(listaDeTarefas)
        try data.write(to: caminhoParaArquivo, options: [.atomicWrite, .completeFileProtection])
    } catch {
        print("Erro ao salvar tarefas: \(error.localizedDescription)")
    }
    print("Tarefa adicionada com sucesso!")
}


func removerTarefa() {
    if listaDeTarefas.isEmpty {
        print("Não há tarefas para remover.")
        return
    }
    
    print("Digite o número da tarefa que deseja remover:")
    listarTarefas()
    if let indice = Int(readLine(strippingNewline: true) ?? ""), indice > 0, indice <= listaDeTarefas.count {
        listaDeTarefas.remove(at: indice - 1)
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(listaDeTarefas)
           

            let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("data.json")
            try data.write(to: fileURL)
        } catch {
            print("Erro ao salvar tarefas: \(error.localizedDescription)")
        }
        
        print("Tarefa removida.")
    } else {
        print("Opção inválida.")
    }
}


func editarTarefa() {
    if listaDeTarefas.isEmpty {
        print("Não há tarefas para editar.")
        return
    }
    print("Digite o número da tarefa que deseja editar:")
    listarTarefas()
    guard let indice = Int(readLine(strippingNewline: true) ?? ""), indice > 0, indice <= listaDeTarefas.count else {
        print("Opção inválida.")
        return
    }
    
    let tarefa = listaDeTarefas[indice-1]
    
    print("Digite o novo título da tarefa:")
    guard let novoTitulo = readLine(), !novoTitulo.isEmpty else {
        print("Título inválido.")
        return
    }
    
    print("Digite a nova descrição da tarefa:")
    guard let novaDescricao = readLine(), !novaDescricao.isEmpty else {
        print("Descrição inválida.")
        return
    }
    
    let novaTarefa = Tarefa(titulo: novoTitulo, descricao: novaDescricao, concluida: tarefa.concluida)
    listaDeTarefas[indice-1] = novaTarefa
    
    do {
        let encoder = JSONEncoder()
        let data = try encoder.encode(listaDeTarefas)
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("data.json")
        try data.write(to: fileURL)
    } catch {
        print("Erro ao salvar tarefas: \(error.localizedDescription)")
    }
    
    print("Tarefa editada com sucesso!")
}


func atualizarTarefa() {
    if listaDeTarefas.isEmpty {
        print("Não há tarefas para atualizar.")
        return
    }
    
    print("Digite o número da tarefa que deseja atualizar:")
    listarTarefas()
    if let indice = Int(readLine(strippingNewline: true) ?? ""), indice > 0, indice <= listaDeTarefas.count {
        var tarefa = listaDeTarefas[indice - 1]
        print("Status atual: \(tarefa.concluida ? "concluída" : "pendente")")
        print("Digite o novo status da tarefa (concluída ou pendente):")
        guard let novoStatus = readLine()?.lowercased(), (novoStatus == "concluída" || novoStatus == "pendente") else {
            print("Status inválido.")
            return
        }
        tarefa.concluida = (novoStatus == "concluída")
        listaDeTarefas[indice - 1] = tarefa
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(listaDeTarefas)
            try data.write(to: caminhoParaArquivo, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Erro ao salvar tarefas: \(error.localizedDescription)")
        }
        print("Tarefa atualizada com sucesso!")
    } else {
        print("Opção inválida.")
    }
}
    

    func menu() {
        while true {
            print("----- Gerenciador de Tarefas -----")
            print("[1] Listar tarefas")
            print("[2] Adicionar nova tarefa")
            print("[3] Remover tarefa")
            print("[4] Editar tarefa")
            print("[5] Atualizar status de tarefa")
            print("[0] Sair")
            print("----------------------------------")
            print("Digite uma opção:")
            
            guard let opcao = readLine(strippingNewline: true), let valorOpcao = Int(opcao) else {
                print("Opção inválida.")
                continue
            }
            
            switch valorOpcao {
            case 0:
                print("Até mais!")
                return
            case 1:
                listarTarefas()
            case 2:
                adicionarTarefa()
            case 3:
                removerTarefa()
            case 4:
                editarTarefa()
            case 5:
                atualizarTarefa()
            default:
                print("Opção inválida.")
            }
        }
    }
    
    menu()
