//
//  GameScene.swift
//  Meu Flappy Bird
//
//  Created by Treinamento on 10/1/19.
//  Copyright © 2019 LiviaHilario. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var passaro = SKSpriteNode ()
    var imagemBG = SKSpriteNode()
    var chao = SKNode()
    var ceu = SKNode()
    var gameOver = false
//    var espacoEntrePipes = 4
    
    
    enum ColliderType: UInt32 {
        case Passaro = 1
        case Objeto = 2
        case EspacoEntrePipes = 4
    }
    
    
    @objc func fazendoPipes() {
        // colocando os canos na tela
        
        ///separando os cones
        let movePipes = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy:0 ), duration: TimeInterval(self.frame.width / 100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes, removePipes])
        
        let lacuna = passaro.size.height * 4
        let movimentoEntre = arc4random() % UInt32(self.frame.height / 2)
        let movimentoPipes = CGFloat(movimentoEntre) - self.frame.height / 4
        
        // colocando primeiro cano
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture)
        pipe1.position = CGPoint(x: self.frame.maxX, y: self.frame.midY + pipeTexture.size().height / 2 + lacuna / 2 + movimentoPipes)
        pipe1.run(movePipes)
        self.addChild(pipe1)
        
        

        // colocando o segundo cone
        let pipe2Texture = SKTexture(imageNamed: "pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipe2Texture)
        pipe2.position = CGPoint(x: self.frame.maxX, y: self.frame.midY - pipe2Texture.size().height / 2 - lacuna / 2 + movimentoPipes )
        pipe2.run(movePipes)
        self.addChild(pipe2)
        
        
        //Quando o passaro encostar no cano 1 o jogo acaba
        pipe1.physicsBody = SKPhysicsBody(rectangleOf:pipeTexture.size())
        pipe1.physicsBody!.isDynamic = false
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Objeto.rawValue
        pipe1.physicsBody!.categoryBitMask = ColliderType.Objeto.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Objeto.rawValue
        
        
        //Quando o passaro encostar no cano 2 o jogo acaba
        pipe2.physicsBody = SKPhysicsBody(rectangleOf:pipe2Texture.size())
        pipe2.physicsBody!.isDynamic = false
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Objeto.rawValue
        pipe2.physicsBody!.categoryBitMask = ColliderType.Objeto.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Objeto.rawValue
        
        // GameOver
        let espacoEntrePipes = SKNode()
        espacoEntrePipes.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + lacuna)
        espacoEntrePipes.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: lacuna ))
        espacoEntrePipes.physicsBody!.isDynamic = false
        espacoEntrePipes.run(moveAndRemovePipes)
        
        espacoEntrePipes.physicsBody!.contactTestBitMask = ColliderType.Passaro.rawValue
        espacoEntrePipes.physicsBody!.categoryBitMask = ColliderType.EspacoEntrePipes.rawValue
        espacoEntrePipes.physicsBody!.collisionBitMask = ColliderType.EspacoEntrePipes.rawValue

        self.addChild(espacoEntrePipes)
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        if contact.bodyA.categoryBitMask == ColliderType.EspacoEntrePipes.rawValue || contact.bodyB.categoryBitMask == ColliderType.EspacoEntrePipes.rawValue {
        
        print("Add one to score")
//        self.speed = 0
//        gameOver = true
        }
        else {
            
            print("Bateu")
        }
    }
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self
        
//        configuracaoDoJogo()
//    }
//
//    func configuracaoDoJogo() {
        
        //novos pipes
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.fazendoPipes), userInfo: nil, repeats: true)
        
        // Declarando as imagens do passaro
        let passaroTexture = SKTexture(imageNamed: "flappy1br.png")
        let passaroTexture2 = SKTexture(imageNamed: "flappy2br.png")
        let acao = SKAction.animate(with: [passaroTexture, passaroTexture2], timePerFrame: 0.1)
        let passaroVoando = SKAction.repeatForever(acao)
        //MARK: -
        passaro = SKSpriteNode (texture: passaroTexture)
        passaro.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        passaro.run(passaroVoando)
        
        
        // Quando o passaro encostar em qualquer parte o jogo acaba
        passaro.physicsBody = SKPhysicsBody(circleOfRadius: passaroTexture.size().height / 2)
        passaro.physicsBody!.contactTestBitMask = ColliderType.Objeto.rawValue
        passaro.physicsBody!.categoryBitMask = ColliderType.Passaro.rawValue
        passaro.physicsBody!.collisionBitMask = ColliderType.Passaro.rawValue
        
        passaro.physicsBody!.isDynamic = false
        
        self.addChild(passaro)
        
        // Limitando o passaro na tela
        chao.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        chao.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        chao.physicsBody!.isDynamic = false
        
        //Quando o passaro encostar no chao o jogo acaba
        chao.physicsBody!.contactTestBitMask = ColliderType.Objeto.rawValue
        chao.physicsBody!.categoryBitMask = ColliderType.Objeto.rawValue
        chao.physicsBody!.collisionBitMask = ColliderType.Objeto.rawValue
        self.addChild(chao)
        
        //Imagem back se mover
        let imagemBGTexture = SKTexture(imageNamed: "bg.png")
        
        let movimentoImagemBG = SKAction.move(by: CGVector(dx: -imagemBGTexture.size().width, dy: 0), duration: 5)
        let mudaImagemBG = SKAction.move(by: CGVector(dx: imagemBGTexture.size().width, dy: 0), duration: 0)
        let movimetarImagemBGSempre = SKAction.repeatForever(SKAction.sequence([movimentoImagemBG, mudaImagemBG]))
        
        var i: CGFloat = 0
        
        while i < 3 {
            //image background
            imagemBG = SKSpriteNode(texture: imagemBGTexture)
            imagemBG.position = CGPoint(x: imagemBGTexture.size().width * i, y: self.frame.midY)
            imagemBG.size.height = self.frame.height
            //pro passaro ficar em cima do background
            imagemBG.zPosition = -1
            imagemBG.run(movimetarImagemBGSempre)
            self.addChild(imagemBG)
            
            i += 1
        }
        
        

    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if gameOver == false {
        
        passaro.physicsBody!.isDynamic = true
        passaro.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 0))
        passaro.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        passaro.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 75))
         print("Pulando")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        
    }
}
