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
    
    
    //essentially just a sprite or character that we gonna animate and move around our screen
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pontuacao = SKLabelNode()
    var score = 0
    var fraseDeGameOver = SKLabelNode()
    var timer = Timer()
//    <<<<<<< HEAD
    
//    =======

    //MARK: - Definindo o colisor com enum
    enum Colisor: UInt32{
        
        case Bird = 1
        case Objeto = 2
        case Espaco = 4
        
    }
    var gameOver = false
    
    @objc func criarTubos () {
        
        //MARK: - Criando animacao do movimento dos tubos
        let animacaoTubos = SKAction.move(by: CGVector(dx: -2 * self.frame.width, dy: 0), duration: TimeInterval(self.frame.width / 100))
        
        let removerTubos = SKAction.removeFromParent()
        
        let movereremoverTubos = SKAction.sequence([animacaoTubos, removerTubos])
        
        
        
        //MARK: Criando o gap
        let gapAltura = bird.size.height * 2
        
        //MARK: limite de altura dos tubos
        let movimentosTubos = arc4random() % UInt32(self.frame.height) / 2
        
        let deslocamentoTubos = CGFloat(movimentosTubos) - self.frame.height / 4
        
        //MARK: - adicionando os tubos
        let pipeTexture = SKTexture(imageNamed: "pipe1.png")
        
        let tubo1 = SKSpriteNode(texture: pipeTexture)
        
        tubo1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + pipeTexture.size().height / 2 + gapAltura + deslocamentoTubos)
        
        tubo1.run(animacaoTubos)
        
        tubo1.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        tubo1.physicsBody!.isDynamic = false
        
        //determinando que tubo 1 é físico
        tubo1.physicsBody!.contactTestBitMask = Colisor.Objeto.rawValue
        tubo1.physicsBody!.categoryBitMask = Colisor.Objeto.rawValue
        tubo1.physicsBody!.collisionBitMask = Colisor.Objeto.rawValue
        
        tubo1.zPosition = -1
        
        self.addChild(tubo1)
        
        let pipeTexture2 = SKTexture(imageNamed: "pipe2.png")
        
        let tubo2 = SKSpriteNode(texture: pipeTexture2)
        
        tubo2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - pipeTexture2.size().height / 2 - gapAltura + deslocamentoTubos)
        
        tubo2.run(animacaoTubos)
        
        tubo2.physicsBody = SKPhysicsBody(rectangleOf: pipeTexture.size())
        tubo2.physicsBody!.isDynamic = false
        
        
        //determinando que tubo 2 é físico
        tubo2.physicsBody!.contactTestBitMask = Colisor.Objeto.rawValue
        tubo2.physicsBody!.categoryBitMask = Colisor.Objeto.rawValue
        tubo2.physicsBody!.collisionBitMask = Colisor.Objeto.rawValue
        
        tubo2.zPosition = -1
        
        self.addChild(tubo2)
        
        let espacoEntreTubos = SKNode()
        
        espacoEntreTubos.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + deslocamentoTubos)
        
        espacoEntreTubos.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: pipeTexture.size().width, height: gapAltura))
        
        espacoEntreTubos.physicsBody!.isDynamic = false
        
        espacoEntreTubos.run(movereremoverTubos)
        
        espacoEntreTubos.physicsBody!.contactTestBitMask = Colisor.Bird.rawValue
        espacoEntreTubos.physicsBody!.categoryBitMask = Colisor.Espaco.rawValue
        espacoEntreTubos.physicsBody!.collisionBitMask = Colisor.Espaco.rawValue
        
        self.addChild(espacoEntreTubos)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if gameOver == false {
            
            if contact.bodyA.categoryBitMask == Colisor.Espaco.rawValue || contact.bodyB.categoryBitMask == Colisor.Espaco.rawValue {
                
                score += 1
                pontuacao.text = String(score)
                
            } else{
                
                
                self.speed = 0
                gameOver = true
                
                timer.invalidate()
                
                fraseDeGameOver.fontName = "Arial"
                fraseDeGameOver.fontSize = 30
                fraseDeGameOver.text = "FIM DE JOGO, Recomeçar?"
                fraseDeGameOver.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                self.addChild(fraseDeGameOver)
            }
        }
        
    }
    
    override func didMove(to view: SKView) {

        self.physicsWorld.contactDelegate = self
        configuracoesDoJogo()
    }
    
    
    func configuracoesDoJogo() {
        
        //Faz a repeticao dos tubos aparecendo na tela a cada 3 segundos
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.criarTubos), userInfo: nil, repeats: true)
        
        //MARK: - cria a textura do fundo
        let bgTexture = SKTexture(imageNamed: "bg.png")
        
        //cria a animacao do fundo
        let moveFundo = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 5)
        
        let mudancaDaAnimacaoFundo = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        
        let moveFundoForever = SKAction.repeatForever(SKAction.sequence([moveFundo, mudancaDaAnimacaoFundo]))
        
        var i : CGFloat = 0
        
        while i < 3 {
            
            bg = SKSpriteNode(texture: bgTexture)
            //seta a posicao no meio da tela
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            
            //arruma o tamanho
            bg.size.height = self.frame.height
            
            //faz o fundo mover
            bg.run(moveFundoForever)
            
            bg.zPosition = -2
            
            self.addChild(bg)
            
            i += 1
            
        }
        
        
        
        //MARK: - cria a textura da imagem do passaro
        let birdTexture = SKTexture(imageNamed: "flappy1br.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2br.png")
        
        //cria animacao
        let animation = SKAction.animate(with: [birdTexture, birdTexture2], timePerFrame: 0.3)
        //faz o loop pra sempre
        let fazFlappyBirdVoar = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture)
        
        //Define a posicao do passarinho no meio da tela
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //funcao do passaro voar
        bird.run(fazFlappyBirdVoar)
        
        
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
        
        bird.physicsBody!.isDynamic = false
        
        
        
        //determinando que Bird é físico
        bird.physicsBody!.contactTestBitMask = Colisor.Objeto.rawValue
        bird.physicsBody!.categoryBitMask = Colisor.Bird.rawValue
        bird.physicsBody!.collisionBitMask = Colisor.Bird.rawValue
        
        //Adiciona o passarinho na ViewController
        self.addChild(bird)
        
        //MARK: - limitador do chao
        let chao = SKNode()
        
        chao.position = CGPoint(x: self.frame.midX, y: -self.frame.height / 2)
        
        chao.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        chao.physicsBody!.isDynamic = false
        
        //determinando que chao é físico
        chao.physicsBody!.contactTestBitMask = Colisor.Objeto.rawValue
        chao.physicsBody!.categoryBitMask = Colisor.Objeto.rawValue
        chao.physicsBody!.collisionBitMask = Colisor.Objeto.rawValue
        
        self.addChild(chao)
        
        
        
        //MARK: - limitador do ceu
        let ceu = SKNode()
        
        ceu.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2)
        
        ceu.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        
        ceu.physicsBody!.isDynamic = false
        
        self.addChild(ceu)
        
        
        //MARK: Mostrar pontuacao
        pontuacao.fontName = "Arial"
        pontuacao.fontSize = 60
        pontuacao.text = "0"
        pontuacao.position = CGPoint(x: self.frame.midX, y: self.frame.height / 2 - 100)

        self.addChild(pontuacao)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //MARK: - aplicando a fisica - gravidade
        
        
        
        if gameOver == false{
            //let birdTexture = SKTexture(imageNamed: "flappy1verde.png")
            //
            //bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height / 2)
            
            bird.physicsBody!.isDynamic = true
            
            bird.physicsBody?.velocity = (CGVector(dx: 0, dy: 0))
            
            bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 65))
        } else {
            
            gameOver = false
            
            score = 0
            
            self.speed = 1
            self.removeAllChildren()
            
            configuracoesDoJogo()
            
            
        }
        
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
