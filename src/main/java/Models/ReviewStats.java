package Models;

/**
 *
 * @author Tran Thanh Van - CE181019
 */
public class ReviewStats {
    private int totalReviews;
    private double averageStars;
    private int fiveStar;
    private int fourStar;
    private int threeStar;
    private int twoStar;
    private int oneStar;

    public ReviewStats() {
    }

    public ReviewStats(int totalReviews, double averageStars, int fiveStar, int fourStar, int threeStar, int twoStar, int oneStar) {
        this.totalReviews = totalReviews;
        this.averageStars = averageStars;
        this.fiveStar = fiveStar;
        this.fourStar = fourStar;
        this.threeStar = threeStar;
        this.twoStar = twoStar;
        this.oneStar = oneStar;
    }

    public int getTotalReviews() {
        return totalReviews;
    }

    public void setTotalReviews(int totalReviews) {
        this.totalReviews = totalReviews;
    }

    public double getAverageStars() {
        return averageStars;
    }

    public void setAverageStars(double averageStars) {
        this.averageStars = averageStars;
    }

    public int getFiveStar() {
        return fiveStar;
    }

    public void setFiveStar(int fiveStar) {
        this.fiveStar = fiveStar;
    }

    public int getFourStar() {
        return fourStar;
    }

    public void setFourStar(int fourStar) {
        this.fourStar = fourStar;
    }

    public int getThreeStar() {
        return threeStar;
    }

    public void setThreeStar(int threeStar) {
        this.threeStar = threeStar;
    }

    public int getTwoStar() {
        return twoStar;
    }

    public void setTwoStar(int twoStar) {
        this.twoStar = twoStar;
    }

    public int getOneStar() {
        return oneStar;
    }

    public void setOneStar(int oneStar) {
        this.oneStar = oneStar;
    }

    @Override
    public String toString() {
        return "ReviewStats{" + "totalReviews=" + totalReviews + ", averageStars=" + averageStars + ", fiveStar=" + fiveStar + ", fourStar=" + fourStar + ", threeStar=" + threeStar + ", twoStar=" + twoStar + ", oneStar=" + oneStar + '}';
    }
    
    
}
