import axios from 'axios';

const service = axios.create({
    timeout: 3000
});

service.interceptors.response.use(
    response => {
        return response;
    }, error => {
        switch (error.response.status) {
            case 400:
                console.error(error)
                break;
            case 401:
                console.error(error)
                break;
            case 403:
                console.error(error)
                break
            case 404:
                console.error(error)
                break
        }
        if (error.response.status >= 500) {
            console.error(error)
        }
        return Promise.reject(error);
    }
);

export default service;
