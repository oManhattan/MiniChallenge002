//
//  Avaliacao.swift
//  MiniChallenge002 iOS
//
//  Created by Elton Freitas on 06/12/22.
//

import StoreKit

class Avaliacao {
    //cria função para o pedido de avaliação
    static func pedidoAvaliacao() {
        //cria contador pra fazer a verificação de quantas vezes a pessoa abriu o app
        var count = 0
        //cria chave no UserDefault para salvar
        count = UserDefaults.standard.integer(forKey: "contador")
        count += 1
        UserDefaults.standard.set(count, forKey: "contador")
        
        //cria condição pra setar quando vai aparecer o pedido (Dps de quantas vezes o usuário abrir, no caso)
        if count == 5{
            //executa avaliação
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
                UserDefaults.standard.set(0, forKey: "contador")
            }
        }
    }
}
