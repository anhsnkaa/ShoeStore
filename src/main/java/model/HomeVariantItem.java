package model;

public class HomeVariantItem {

    private final Product product;
    private final String color;
    private final String imageUrl;

    public HomeVariantItem(Product product, String color, String imageUrl) {
        this.product = product;
        this.color = color;
        this.imageUrl = imageUrl;
    }

    public Product getProduct() {
        return product;
    }

    public String getColor() {
        return color;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public String getDisplayName() {
        if (product == null) {
            return color == null ? "" : color;
        }

        if (color == null || color.isBlank()) {
            return product.getName();
        }

        return product.getName() + " - " + color;
    }
}
