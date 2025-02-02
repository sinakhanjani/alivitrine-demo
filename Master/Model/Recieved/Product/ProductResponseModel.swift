//  Created By GsonToMapper (MohammadFallah)

import ObjectMapper

struct ProductResponseModel : Mappable {

    var product : ShoeModel?
    var shop : MineralModel?
    var category : CategoryChildModel?
    var specifications : [SpecificationModel]?
    var similar_product : [MineralModel]?
    var product_images : [ImageModel]?
    var product_sizes: [ShoeSizeModel]?
    var added_to_favorites : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        product <- map ["product"]
        shop <- map ["shop"]
        category <- map ["category"]
        specifications <- map ["specifications"]
        similar_product <- map ["similar_product"]
        product_images <- map ["product_images"]
        product_sizes <- map ["product_sizes"]
        added_to_favorites <- map ["added_to_favorites"]

    }
}
