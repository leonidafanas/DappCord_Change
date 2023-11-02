import { ethers } from 'ethers'

const Navigation = ({ account, setAccount}) => {

  const connectHandler = async() => {
    const accounts = await window.ethereum.request({method: 'eth_requestAccounts'})
    const account = ethers.utils.getAddress(accounts[0])
    setAccount(account) //The Hook takes an initial state value as an argument (account) and returns an updated state value whenever the setter function is called
  }

  return (
    <nav>
    <div className='nav__brand'>
      <h1>Dappcord</h1>
    </div>

    {account ? (    //since in App.js useState(null), so here Navigation(account '= null') which means account set to 'null' -> here is no 'account' from start
      <button
      type ="button"
      className = 'nav__connect'
      >
      {account.slice(0,6) + '...' + account.slice(38,42)}
    </button>
      ) : (
      <button
      type ="button"
      className = 'nav__connect'
      onClick = {connectHandler}
      >
      Connect
    </button>
      )}

    </nav>
  );
}

export default Navigation;