package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "Products")
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(columnDefinition = "NVARCHAR(150)", nullable = false)
    private String name;

    private double price;

    @Column(columnDefinition = "NVARCHAR(MAX)")
    private String description;

    // 🔥 Gender (Nam / Nữ)
    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Enumerated(EnumType.STRING)
    @Column(name = "collection")
    private CollectionSeason collectionSeason;

    @Column(name = "saleStartAt")
    private LocalDateTime saleStartAt;

    @Column(name = "saleEndAt")
    private LocalDateTime saleEndAt;

    // 🔥 Giảm giá (%)
    private Double discount;

    // 🔥 Sản phẩm nổi bật
    private Boolean featured;

    // 🔥 Ngày tạo (để làm New Arrival)
    private LocalDateTime createdDate;

    // ===== RELATION =====
    @ManyToOne
    @JoinColumn(name = "category_id")
    private Category category;

    @OneToMany(mappedBy = "product",
            cascade = CascadeType.ALL,
            orphanRemoval = true,
            fetch = FetchType.LAZY)
    private List<ProductSize> sizes = new ArrayList<>();

    @OneToMany(mappedBy = "product",
            cascade = CascadeType.ALL,
            orphanRemoval = true,
            fetch = FetchType.EAGER)
    private List<ProductImage> images = new ArrayList<>();

    // ===== CONSTRUCTOR =====
    public Product() {
        this.createdDate = LocalDateTime.now();
        this.discount = 0.0;
        this.featured = false;
        this.collectionSeason = CollectionSeason.SPRING;
    }

    // ===== BUSINESS METHOD =====
    public double getFinalPrice() {
        if (!isSaleActive()) {
            return price;
        }

        double safeDiscount = (discount == null) ? 0.0 : discount;
        safeDiscount = Math.max(0.0, Math.min(100.0, safeDiscount));
        return price * (1 - safeDiscount / 100);
    }

    @Transient
    public boolean isHot() {
        return Boolean.TRUE.equals(featured);
    }

    @Transient
    public boolean isSaleActive() {
        if (discount == null || discount <= 0) {
            return false;
        }

        LocalDateTime now = LocalDateTime.now();
        if (saleStartAt != null && now.isBefore(saleStartAt)) {
            return false;
        }

        if (saleEndAt != null && now.isAfter(saleEndAt)) {
            return false;
        }

        return true;
    }

    @Transient
    public int getDiscountPercent() {
        if (discount == null || discount <= 0) {
            return 0;
        }

        return (int) Math.round(discount);
    }

    public String getMainImage() {
        for (ProductImage img : images) {
            if (Boolean.TRUE.equals(img.isIsMain())) {
                return img.getImageUrl();
            }
        }
        return null;
    }

    public void addSize(ProductSize size) {
        sizes.add(size);
        size.setProduct(this);
    }

    public void addImage(ProductImage image) {
        images.add(image);
        image.setProduct(this);
    }

    // ===== GETTER / SETTER =====
    public int getId() {
        return id;
    }

    // ❗ Không nên dùng setId khi persist
    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public CollectionSeason getCollectionSeason() {
        return collectionSeason;
    }

    public void setCollectionSeason(CollectionSeason collectionSeason) {
        this.collectionSeason = collectionSeason;
    }

    public Double getDiscount() {
        return discount;
    }

    public void setDiscount(Double discount) {
        this.discount = discount;
    }

    public LocalDateTime getSaleStartAt() {
        return saleStartAt;
    }

    public void setSaleStartAt(LocalDateTime saleStartAt) {
        this.saleStartAt = saleStartAt;
    }

    public LocalDateTime getSaleEndAt() {
        return saleEndAt;
    }

    public void setSaleEndAt(LocalDateTime saleEndAt) {
        this.saleEndAt = saleEndAt;
    }

    public Boolean getFeatured() {
        return featured;
    }

    public void setFeatured(Boolean featured) {
        this.featured = featured;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public List<ProductSize> getSizes() {
        return sizes;
    }

    public void setSizes(List<ProductSize> sizes) {
        this.sizes = sizes;
    }

    public List<ProductImage> getImages() {
        return images;
    }

    public void setImages(List<ProductImage> images) {
        this.images = images;
    }
}
