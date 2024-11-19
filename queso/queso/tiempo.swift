//
//  tiempo.swift
//  queso
//
//  Created by Alumno on 19/11/24.
//

import UIKit

class TemporizadorDeJuego {
    
    var etiquetaTemporizador: UILabel!
    var temporizador: Timer?
    var tiempoRestante = 90
    var viewController: ViewController?
    
    init(límiteDeTiempo: Int) {
        self.tiempoRestante = límiteDeTiempo
        self.etiquetaTemporizador = UILabel()
        self.etiquetaTemporizador.frame = CGRect(x: 100, y: 200, width: 200, height: 50)
        self.etiquetaTemporizador.textAlignment = .center
        self.etiquetaTemporizador.font = UIFont.systemFont(ofSize: 36)
        self.etiquetaTemporizador.text = "\(tiempoRestante)"
    }
    
    func iniciar() {
        comenzarCuentaRegresiva()
    }
    
    func comenzarCuentaRegresiva() {
        temporizador = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(actualizarTiempo), userInfo: nil, repeats: true)
    }
    
    func detenerTemporizador() {
        temporizador?.invalidate()
    }
    
    func reiniciarTemporizador() {
        tiempoRestante = 90
        viewController?.actualizarEtiquetaTemporizador(tiempoRestante: tiempoRestante)
        detenerTemporizador()
        iniciar()
    }
    
    @objc func actualizarTiempo() {
        tiempoRestante -= 1
        viewController?.actualizarEtiquetaTemporizador(tiempoRestante: tiempoRestante)
        if tiempoRestante == 0 {
            detenerTemporizador()
            viewController?.mostrarMensajeFinJuego()
        }
    }
}
