// ====== Order Status Labels and Colors ======
const ORDER_STATUS_LABELS = ["Pending", "Processing", "Shipped", "Delivered"];
const ORDER_STATUS_COLORS = [
    "#2563eb", // Pending (blue)
    "#a78bfa", // Processing (purple)
    "#fbbf24", // Shipped (yellow)
    "#16a34a", // Delivered (green)
];

// ================== DASHBOARD MAIN FUNCTION ==================
window.initDashboardTabs = function () {
    // ---- Chart Cleanup ----
    if (window.revenueChart && typeof window.revenueChart.destroy === 'function')
        window.revenueChart.destroy();
    if (window.statusPieChart && typeof window.statusPieChart.destroy === 'function')
        window.statusPieChart.destroy();

    // ---- Format Date ----
    function formatDate(dateString) {
        if (!dateString)
            return '';
        if (dateString.includes('/'))
            return dateString;
        const parts = dateString.split('-');
        if (parts.length === 3)
            return `${parts[2]}/${parts[1]}`; // dd/MM
        if (parts.length === 2)
            return `${parts[1]}/${parts[0]}`; // MM/yyyy
        return dateString;
    }

    // ---- Draw Revenue Chart ----
    function initRevenueChart(data, label) {
        const canvas = document.getElementById('revenueChart');
        if (!canvas)
            return;
        const noDataMsg = canvas.parentElement.querySelector('.no-data-msg');
        if (noDataMsg)
            noDataMsg.remove();
        if (!data || data.length === 0) {
            const noData = document.createElement('p');
            noData.innerHTML = 'No revenue data available';
            noData.className = 'no-data-msg text-center text-gray-400 py-12 text-lg';
            canvas.parentElement.appendChild(noData);
            canvas.style.display = 'none';
            return;
        }
        canvas.style.display = '';
        const ctx = canvas.getContext('2d');
        if (window.revenueChart && typeof window.revenueChart.destroy === 'function')
            window.revenueChart.destroy();
        const labels = data.map(d => formatDate(d.period));
        const revenues = data.map(d => typeof d.revenue === "number" ? d.revenue : parseFloat(d.revenue) || 0);
        window.revenueChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels,
                datasets: [{
                        label: label || 'Revenue',
                        data: revenues,
                        borderColor: '#2563eb',
                        backgroundColor: 'rgba(37, 99, 235, 0.10)',
                        borderWidth: 3,
                        pointRadius: 5,
                        pointHoverRadius: 7,
                        fill: true,
                        tension: 0.35
                    }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {display: false},
                    tooltip: {
                        callbacks: {
                            label: ctx => new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND', maximumFractionDigits: 0}).format(ctx.parsed.y)
                        }
                    }
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            callback: value => new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND', maximumFractionDigits: 0}).format(value)
                        }
                    }
                }
            }
        });
    }

    // ---- Draw Order Status Pie Chart ----
    function initStatusPieChart(data) {
        const canvas = document.getElementById('statusPieChart');
        if (!canvas)
            return;
        if (window.statusPieChart && typeof window.statusPieChart.destroy === 'function')
            window.statusPieChart.destroy();
        const values = ORDER_STATUS_LABELS.map(key => data && typeof data[key] !== "undefined" ? data[key] : 0);
        window.statusPieChart = new Chart(canvas, {
            type: 'pie',
            data: {
                labels: ORDER_STATUS_LABELS,
                datasets: [{
                        data: values,
                        backgroundColor: ORDER_STATUS_COLORS,
                        borderColor: '#fff',
                        borderWidth: 2
                    }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {
                        display: true,
                        position: 'right',
                        labels: {
                            boxWidth: 18,
                            font: {size: 15, family: 'inherit', weight: '500'}
                        }
                    },
                    tooltip: {
                        callbacks: {
                            label: context => `${context.label}: ${context.parsed}`
                        }
                    }
                }
            }
        });
    }

    // ---- Get JSON data from Script Tag ----
    function getJson(id, def = []) {
        const el = document.getElementById(id);
        if (!el)
            return def;
        try {
            return JSON.parse(el.textContent);
        } catch (e) {
            return def;
    }
    }

    const revenueDaily = getJson('revenueDailyScript', []);
    const revenueMonthly = getJson('revenueMonthlyScript', []);
    const revenueYearly = getJson('revenueYearlyScript', []);
    const statusPieData = getJson('orderStatusDataScript', {});

    // ---- Show correct Filter Form ----
    function showFilterForm(type) {
        document.querySelectorAll('.filter-form').forEach(f => f.classList.add('hidden'));
        const form = document.getElementById('filter-form-' + type);
        if (form) {
            form.classList.remove('hidden');
            const input = form.querySelector('input[name="filterType"]');
            if (input)
                input.value = type;
        }
    }

    // ---- Tab Switching ----
    function setTabActive(btn) {
        document.querySelectorAll('.chart-tab-btn').forEach(b => {
            b.classList.remove('bg-indigo-500', 'text-white', 'shadow', 'border-indigo-500', 'border-2');
            b.classList.add('bg-gray-100', 'text-gray-800', 'border', 'border-gray-300');
        });
        btn.classList.add('bg-indigo-500', 'text-white', 'shadow', 'border-indigo-500', 'border-2');
        btn.classList.remove('bg-gray-100', 'text-gray-800', 'border', 'border-gray-300');
    }
    ['daily', 'monthly', 'yearly'].forEach(type => {
        const btn = document.getElementById(`btn-${type}`);
        if (btn) {
            btn.onclick = () => {
                setTabActive(btn);
                showFilterForm(type);
                if (type === "daily")
                    initRevenueChart(revenueDaily, "30 Day Revenue");
                else if (type === "monthly")
                    initRevenueChart(revenueMonthly, "Monthly Revenue");
                else
                    initRevenueChart(revenueYearly, "Yearly Revenue");
                initStatusPieChart(statusPieData);
            };
        }
    });

    // ---- Filter Submit (validation) ----
    document.querySelectorAll('.filter-submit-btn').forEach(btn => {
        btn.onclick = function (e) {
            e.preventDefault();
            const form = btn.closest('form');
            if (!form)
                return;
            const type = form.id.replace('filter-form-', '');
            let valid = true, msg = "";
            if (type === "daily") {
                const from = form.querySelector('input[name="startDate"]').value;
                const to = form.querySelector('input[name="endDate"]').value;
                if (!from || !to)
                    valid = false, msg = "Please select both start and end dates.";
                else if (from > to)
                    valid = false, msg = "The start date must be before or equal to the end date.";
                else {
                    const diffDays = Math.ceil((new Date(to) - new Date(from)) / (1000 * 60 * 60 * 24)) + 1;
                    if (diffDays > 30)
                        valid = false, msg = "You can select up to 30 days only.";
                }
            }
            if (type === "monthly") {
                const from = form.querySelector('input[name="startMonth"]').value;
                const to = form.querySelector('input[name="endMonth"]').value;
                if (!from || !to)
                    valid = false, msg = "Please select both start and end months.";
                else if (from > to)
                    valid = false, msg = "The start month must be before or equal to the end month.";
            }
            if (type === "yearly") {
                const from = Number(form.querySelector('input[name="startYear"]').value);
                const to = Number(form.querySelector('input[name="endYear"]').value);
                if (!from || !to)
                    valid = false, msg = "Please enter both start and end years.";
                else if (from > to)
                    valid = false, msg = "The start year must be before or equal to the end year.";
                else if (from < 2000 || to > 2100)
                    valid = false, msg = "Years are allowed only from 2000 to 2100.";
            }
            if (!valid) {
                if (window.Swal) {
                    Swal.fire({
                        icon: 'warning',
                        title: '<span class="font-bold text-lg">Error</span>',
                        html: `<span class="text-gray-700 text-base">${msg}</span>`,
                        confirmButtonColor: '#6366f1',
                        customClass: {
                            popup: 'rounded-xl shadow-lg px-8 py-6',
                            title: 'mt-2 mb-2',
                            confirmButton: 'px-8 py-2 rounded-lg font-bold text-white'
                        }
                    });
                } else
                    alert(msg);
                return false;
            }
            const params = [{name: 'filterType', value: type}];
            if (type === "daily") {
                params.push({name: 'startDate', value: form.querySelector('input[name="startDate"]').value});
                params.push({name: 'endDate', value: form.querySelector('input[name="endDate"]').value});
            } else if (type === "monthly") {
                params.push({name: 'startMonth', value: form.querySelector('input[name="startMonth"]').value});
                params.push({name: 'endMonth', value: form.querySelector('input[name="endMonth"]').value});
            } else if (type === "yearly") {
                params.push({name: 'startYear', value: form.querySelector('input[name="startYear"]').value});
                params.push({name: 'endYear', value: form.querySelector('input[name="endYear"]').value});
            }
            loadContent('dashboard', true, params);
        };
    });

    // ---- On Page Load (init) ----
    const filterTypeDefault = document.getElementById('filterTypeValue');
    const type = filterTypeDefault ? (filterTypeDefault.value || 'daily') : 'daily';
    showFilterForm(type);
    const btnActive = document.getElementById('btn-' + type);
    if (btnActive)
        setTabActive(btnActive);
    if (type === "daily")
        initRevenueChart(revenueDaily, "30 Day Revenue");
    else if (type === "monthly")
        initRevenueChart(revenueMonthly, "Monthly Revenue");
    else if (type === "yearly")
        initRevenueChart(revenueYearly, "Yearly Revenue");
    initStatusPieChart(statusPieData);
};

window.addEventListener("DOMContentLoaded", window.initDashboardTabs);
