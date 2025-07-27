const reloadCart = async () => {
    try {
        const response = await fetch("/carts?type=total");
        if (!response.ok) throw new Error("Failed to fetch");

        const result = await response.json();
        if (result.isSuccess) {
            console.log("Tổng số lượng:",result.total );
            document.getElementById("cartTotal").innerText = result.total
        } else {
            console.error("Error from server:", result.message || "Something is wrong");
        }
    } catch (error) {
        console.error("Error when call API:", error);
    }
};


const reloadCustomer = async () => {
    try {
        const response = await fetch("/carts?type=total");
        if (!response.ok) throw new Error("Failed to fetch");

        const result = await response.json();
        if (result.isSuccess) {
            console.log("Tổng số lượng:",result.total );
            document.getElementById("cartTotal").innerText = result.total
        } else {
            console.error("Error from server:", result.message || "Something is wrong");
        }
    } catch (error) {
        console.error("Error when call API:", error);
    }
};