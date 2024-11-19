//
//  ViewController.swift
//  queso
//
//  Created by Alumno on 19/11/24.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource {
    
    var coleccionDeCartas: UICollectionView!
    var juego: JuegoDeCartas!
    var temporizadorDelJuego: TemporizadorDeJuego!
    var etiquetaTemporizador: UILabel!
    var botonReiniciar: UIButton!
    var botonTerminarJuego: UIButton!
    var etiquetaFinJuego: UILabel?
    var imagenFondoFinJuego: UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        juego = JuegoDeCartas()
        temporizadorDelJuego = TemporizadorDeJuego(límiteDeTiempo: 90)
        temporizadorDelJuego.viewController = self
        
        let diseño = UICollectionViewFlowLayout()
        let anchoCarta = (self.view.frame.width - 50) / 4
        let altoCarta = anchoCarta
        diseño.itemSize = CGSize(width: anchoCarta, height: altoCarta)
        diseño.minimumInteritemSpacing = 10
        diseño.minimumLineSpacing = 10
        diseño.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)

        coleccionDeCartas = UICollectionView(frame: CGRect(x: 20, y: 100, width: self.view.frame.width - 40, height: self.view.frame.height - 200), collectionViewLayout: diseño)
        coleccionDeCartas.dataSource = self
        coleccionDeCartas.register(CeldaCarta.self, forCellWithReuseIdentifier: "CeldaCarta")
        coleccionDeCartas.backgroundColor = .black  
        self.view.addSubview(coleccionDeCartas)
        etiquetaTemporizador = UILabel()
        etiquetaTemporizador.frame = CGRect(x: 100, y: 50, width: 200, height: 50)
        etiquetaTemporizador.textAlignment = .center
        etiquetaTemporizador.font = UIFont.systemFont(ofSize: 36)
        etiquetaTemporizador.textColor = .white
        etiquetaTemporizador.text = "\(temporizadorDelJuego.tiempoRestante)"
        self.view.addSubview(etiquetaTemporizador)
        
        temporizadorDelJuego.iniciar()
        botonReiniciar = UIButton(type: .system)
        botonReiniciar.frame = CGRect(x: 50, y: self.view.frame.height - 100, width: 100, height: 50)
        botonReiniciar.setTitle("Reiniciar", for: .normal)
        botonReiniciar.addTarget(self, action: #selector(reiniciarJuego), for: .touchUpInside)
        self.view.addSubview(botonReiniciar)
        
        botonTerminarJuego = UIButton(type: .system)
        botonTerminarJuego.frame = CGRect(x: self.view.frame.width - 150, y: self.view.frame.height - 100, width: 100, height: 50)
        botonTerminarJuego.setTitle("Terminar", for: .normal)
        botonTerminarJuego.addTarget(self, action: #selector(terminarJuego), for: .touchUpInside)
        self.view.addSubview(botonTerminarJuego)
    }
    
    func collectionView(_ coleccionDeCartas: UICollectionView, numberOfItemsInSection sección: Int) -> Int {
        return juego.imagenesCartas.count
    }
    
    func collectionView(_ coleccionDeCartas: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = coleccionDeCartas.dequeueReusableCell(withReuseIdentifier: "CeldaCarta", for: indexPath) as! CeldaCarta
        
        let gestoToque = UITapGestureRecognizer(target: self, action: #selector(cartaTocada(_:)))
        celda.addGestureRecognizer(gestoToque)
        celda.indexPath = indexPath
        juego.configurarCelda(celda, para: indexPath)
        
        return celda
    }
    
    @objc func cartaTocada(_ gesto: UITapGestureRecognizer) {
        guard let celda = gesto.view as? CeldaCarta, let indexPath = celda.indexPath else { return }
 
        if juego.sePuedeVoltearCarta(at: indexPath) {
            juego.voltearCarta(at: indexPath)
            coleccionDeCartas.reloadItems(at: [indexPath])
            
            if juego.cartasSeleccionadas.count == 2 {
                juego.comprobarPareja { [weak self] in
                    self?.coleccionDeCartas.reloadData()
                }
            }
        }
    }
    
    func mostrarMensajeFinJuego() {
        imagenFondoFinJuego?.removeFromSuperview()
        etiquetaFinJuego?.removeFromSuperview()
        
        imagenFondoFinJuego = UIImageView(frame: CGRect(x: 100, y: 300, width: 200, height: 100))
        imagenFondoFinJuego?.image = UIImage(named: "tinga")
        imagenFondoFinJuego?.contentMode = .scaleAspectFill
        self.view.addSubview(imagenFondoFinJuego!)
        
        etiquetaFinJuego = UILabel()
        etiquetaFinJuego?.frame = CGRect(x: 0, y: 0, width: imagenFondoFinJuego!.frame.width, height: imagenFondoFinJuego!.frame.height)
        etiquetaFinJuego?.textAlignment = .center
        etiquetaFinJuego?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        etiquetaFinJuego?.text = "MAMASTE"
        etiquetaFinJuego?.textColor = .red
        etiquetaFinJuego?.numberOfLines = 0
        imagenFondoFinJuego?.addSubview(etiquetaFinJuego!)
    }
    func actualizarEtiquetaTemporizador(tiempoRestante: Int) {
        etiquetaTemporizador.text = "\(tiempoRestante)"
    }
    
    @objc func reiniciarJuego() {
        imagenFondoFinJuego?.removeFromSuperview()
        etiquetaFinJuego?.removeFromSuperview()
        juego.reiniciarJuego()
        temporizadorDelJuego.reiniciarTemporizador()
        coleccionDeCartas.reloadData()
    }
    @objc func terminarJuego() {
        temporizadorDelJuego.detenerTemporizador()
        mostrarMensajeFinJuego()
    }
}
