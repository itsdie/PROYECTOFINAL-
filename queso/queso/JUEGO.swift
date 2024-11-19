//
//  JUEGO.swift
//  queso
//
//  Created by Alumno on 19/11/24.
//

import UIKit

class JuegoDeCartas {
    var imagenesCartas: [UIImage?]
    var cartasVolteadas: [IndexPath]
    var cartasEmparejadas: [IndexPath]
    var cartasSeleccionadas: [IndexPath]
    
    init() {
        imagenesCartas = [
            UIImage(named: "mitzuri"),
            UIImage(named: "mitzuri"),
            UIImage(named: "morido"),
            UIImage(named: "morido"),
            UIImage(named: "pilar"),
            UIImage(named: "pilar"),
            UIImage(named: "roca"),
            UIImage(named: "roca"),
            UIImage(named: "amen"),
            UIImage(named: "amen"),
            UIImage(named: "viento"),
            UIImage(named: "viento")
        ]
        
        cartasVolteadas = []
        cartasEmparejadas = []
        cartasSeleccionadas = []
        
        mezclarImagenes()
    }
    
    func mezclarImagenes() {
        imagenesCartas.shuffle()
    }
    
    func configurarCelda(_ celda: CeldaCarta, para indexPath: IndexPath) {
        if cartasEmparejadas.contains(indexPath) {
            celda.ponerCarta(imagen: imagenesCartas[indexPath.row], estaVolteada: true)
        } else if cartasVolteadas.contains(indexPath) {
            celda.ponerCarta(imagen: imagenesCartas[indexPath.row], estaVolteada: true)
        } else {
            celda.ponerCarta(imagen: nil, estaVolteada: false)
        }
    }
    
    func sePuedeVoltearCarta(at indexPath: IndexPath) -> Bool {
        return !cartasEmparejadas.contains(indexPath) && !cartasVolteadas.contains(indexPath)
    }
    
    func voltearCarta(at indexPath: IndexPath) {
        cartasVolteadas.append(indexPath)
        cartasSeleccionadas.append(indexPath)
    }
    
    func comprobarPareja(completion: @escaping () -> Void) {
        guard cartasSeleccionadas.count == 2 else { return }
        
        let primerIndice = cartasSeleccionadas[0]
        let segundoIndice = cartasSeleccionadas[1]
        
        if imagenesCartas[primerIndice.row] == imagenesCartas[segundoIndice.row] {
            cartasEmparejadas.append(contentsOf: cartasSeleccionadas)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.cartasVolteadas.removeAll { $0 == primerIndice || $0 == segundoIndice }
            self.cartasSeleccionadas.removeAll()
            completion()
        }
    }
    
    func reiniciarJuego() {
        cartasVolteadas.removeAll()
        cartasEmparejadas.removeAll()
        cartasSeleccionadas.removeAll()
        mezclarImagenes()
    }
}
