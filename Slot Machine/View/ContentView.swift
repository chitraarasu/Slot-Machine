//
//  ContentView.swift
//  Slot Machine
//
//  Created by kirshi on 6/25/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - PROPERTIES
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var betAmount: Int = 10
    
    @State private var reels: Array = [0, 1, 2]
    @State private var showingInfoView: Bool = false
    @State private var showingModal: Bool = false
    @State private var animatingSymbol: Bool = false
    @State private var animatingModel: Bool = false
    
    //MARK: - FUNCTION
    
    func spinReel(){
        reels = symbols.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        
        playSound(sound: "spin", type: "mp3")
        
        checkWinning()
    }
    
    func checkWinning(){
        if(reels[0] == reels[1] && reels[1] == reels[2] && reels[2] == reels[1]){
            playerWins()
            if(coins > highScore){
                newHighScore()
            } else {
                playSound(sound: "win", type: "mp3")
            }
        } else {
            playerLoses()
        }
        
        isGameOver()
    }
    
    func playerWins(){
        coins += betAmount * 10
    }
    
    func newHighScore(){
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
        playSound(sound: "high-score", type: "mp3")
    }
    
    func playerLoses(){
        coins -= betAmount
    }
    
    func activateBet20(){
        betAmount = 20
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func activateBet10(){
        betAmount = 10
        playSound(sound: "casino-chips", type: "mp3")
    }
    
    func isGameOver(){
        if coins <= 0 {
            showingModal = true
            playSound(sound: "game-over", type: "mp3")
        }
    }
    
    func resetGame(){
        UserDefaults.standard.set(0, forKey: "HighScore")
        highScore = 0
        coins = 100
        activateBet10()
        playSound(sound: "chimeup", type: "mp3")
    }
    
    //MARK: - BODY
    
    var body: some View {
        ZStack {
            //MARK: - BACKGROUND
            LinearGradient(gradient: Gradient(colors: [Color("ColorPink"), Color("ColorPurple")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            //MARK: - INTERFACE
            VStack(alignment: .center, spacing: 5) {
                //MARK: - HEADER
                
                LogoView()
                
                Spacer()
                
                //MARK: - SCORE
                
                HStack {
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLableStyle()
                            .multilineTextAlignment(.trailing)
                        
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    }
                    .modifier(ScoreContainerModifier())
                    
                    Spacer()
                    
                    HStack {
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        
                        Text("Your\nCoins".uppercased())
                            .scoreLableStyle()
                            .multilineTextAlignment(.leading)
                    }
                    .modifier(ScoreContainerModifier())
                }
                
                Spacer()
                
                //MARK: - SLOT MACHINE
                
                VStack(alignment: .center, spacing: 0) {
                    //MARK: - REEL #1
                    
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImageModifier())
                            .opacity(animatingSymbol ? 1 : 0)
                            .offset(y: animatingSymbol ? 0 : -50)
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear {
                                animatingSymbol.toggle()
                                playSound(sound: "riseup", type: "mp3")
                            }
                    }
                    
                    HStack {
                        
                        //MARK: - REEL #2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear {
                                    animatingSymbol.toggle()
                                }
                        }
                        
                        Spacer()
                        
                        
                        //MARK: - REEL #3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImageModifier())
                                .opacity(animatingSymbol ? 1 : 0)
                                .offset(y: animatingSymbol ? 0 : -50)
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear {
                                    animatingSymbol.toggle()
                                }
                        }
                    }
                    
                    //MARK: - SPIN BUTTON
                    
                    Button {
                        
                        withAnimation {
                            animatingSymbol = false
                        }
                        
                        spinReel()
                        
                        withAnimation {
                            animatingSymbol = true
                        }
                    } label: {
                        ZStack {
                            Image("gfx-spin")
                                .renderingMode(.original)
                                .resizable()
                                .modifier(ImageModifier())
                        }
                    }
                    
                }
                .layoutPriority(2)
                
                //MARK: - FOOTER
                
                Spacer()
                
                HStack {
                    //MARK: - BET 20
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button {
                            activateBet20()
                        } label: {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(betAmount == 20 ? Color("ColorYellow") : .white)
                                .modifier(NetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(betAmount == 20 ? 1 : 0)
                            .offset(x: betAmount == 20 ? 0 : 20)
                            .modifier(CasinoChipsModifier())
                    }
                    
                    Spacer()
                    
                    //MARK: - BET 10
                    
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .opacity(betAmount == 10 ? 1 : 0)
                            .offset(x: betAmount == 10 ? 0 : -20)
                            .modifier(CasinoChipsModifier())
                        
                        Button {
                            activateBet10()
                        } label: {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(betAmount == 10 ? Color("ColorYellow")  : .white)
                                .modifier(NetNumberModifier())
                        }
                        .modifier(BetCapsuleModifier())
                    }
                    
                }
            }
            //MARK: - BUTTONS
            .overlay(
                //MARK: - RESET
                Button(action: {
                    resetGame()
                }, label: {
                    Image(systemName: "arrow.2.circlepath.circle")
                })
                .modifier(ButtonModifier()), alignment: .topLeading
            )
            .overlay(
                //MARK: - INFO
                Button(action: {
                    showingInfoView = true
                }, label: {
                    Image(systemName: "info.circle")
                })
                .modifier(ButtonModifier()), alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth: 720)
            .blur(radius: $showingModal.wrappedValue ? 5 : 0, opaque: false)
            
            //MARK: - POPUP
            
            if $showingModal.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack").edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Text("GAME OVER")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing:  16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: 72)
                            
                            Text("Bad luck! You lost all of the coins. \nLet's play again!")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.gray)
                                .layoutPriority(1)
                            
                            Button {
                                showingModal = false
                                coins = 100
                                animatingModel = false
                                activateBet10()
                            } label: {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .frame(minWidth: 128)
                                    .background {
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    }
                            }

                        }
                        
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack") ,radius: 6, x: 0, y: 8)
                    .opacity($animatingModel.wrappedValue ? 1 : 0)
                    .offset(y: $animatingModel.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response: 0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear {
                        animatingModel = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingInfoView) {
            InfoView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
