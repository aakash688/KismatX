import { AppDataSource } from './src/config/typeorm.config.js';

async function checkDeposits() {
    try {
        await AppDataSource.initialize();
        
        const users = await AppDataSource.query(`
            SELECT user_id, first_name, last_name, deposit_amount 
            FROM users
        `);
        
        console.log('\n📊 User Deposit Summary:');
        console.log('='.repeat(80));
        
        let total = 0;
        users.forEach(user => {
            const amount = parseFloat(user.deposit_amount) || 0;
            total += amount;
            console.log(`${user.user_id.padEnd(15)} ${(user.first_name + ' ' + user.last_name).padEnd(25)} ₹${amount.toFixed(2)}`);
        });
        
        console.log('='.repeat(80));
        console.log(`Total Deposits: ₹${total.toFixed(2)}`);
        console.log('\n');
        
        await AppDataSource.destroy();
    } catch (error) {
        console.error('Error:', error);
        process.exit(1);
    }
}

checkDeposits();






