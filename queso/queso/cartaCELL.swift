//
//  cartaCELL.swift
//  queso
//
//  Created by Alumno on 19/11/24.
//

import UIKit

class CeldaCarta: UICollectionViewCell {
    var vistaCarta: UIView!
    var vistaFrontal: UIImageView!
    var vistaTrasera: UIImageView!
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        vistaCarta = UIView(frame: self.contentView.bounds)
        vistaCarta.layer.cornerRadius = 10
        vistaCarta.layer.masksToBounds = true
        self.contentView.addSubview(vistaCarta)
        
        vistaFrontal = UIImageView(frame: self.contentView.bounds)
        vistaFrontal.contentMode = .scaleAspectFill
        vistaCarta.addSubview(vistaFrontal)
        
        vistaTrasera = UIImageView(frame: self.contentView.bounds)
        vistaTrasera.contentMode = .scaleAspectFill
        vistaTrasera.image = UIImage(named: "carta")
        vistaCarta.addSubview(vistaTrasera)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) no esta padrino")
    }
    func ponerCarta(imagen: UIImage?, estaVolteada: Bool) {
        if estaVolteada {
            vistaFrontal.image = imagen
            vistaFrontal.isHidden = false
            vistaTrasera.isHidden = true
        } else {
            vistaFrontal.isHidden = true
            vistaTrasera.isHidden = false
        }
    }
}
